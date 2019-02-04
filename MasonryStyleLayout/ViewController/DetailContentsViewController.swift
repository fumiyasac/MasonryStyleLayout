//
//  DetailContentsViewController.swift
//  MasonryStyleLayout
//
//  Created by 酒井文也 on 2019/01/22.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import UIKit

final class DetailContentsViewController: UIViewController {

    // ViewModelの初期化に必要な要素の定義
    private let notificationCenter = NotificationCenter()
    private let state = PhotoGalleryDetailState()
    private let api = MealsAPIManager.shared

    // 遷移元から引き渡されるIDとPhotoEntity
    private var targetId: Int!
    private var targetPhotoEntity: PhotoEntity? = nil
    private var targetRecommendPhotos: [PhotoEntity] = [] {
        didSet {
            self.reloadRelatedContentsCollectionView()
        }
    }

    // 写真表示用のPageViewController
    private var targetPhotosUrls: [URL?] = []
    private var pageViewController: UIPageViewController!
    private var photoPageViewControllers: [UIViewController] = []

    // ViewModelの初期化
    private lazy var viewModel = PhotoGalleryDetailViewModel(notificationCenter: notificationCenter, state: state, api: api)

    @IBOutlet weak private var detailPhotoPageControl: UIPageControl!

    @IBOutlet weak private var detailPickButtonView: PhotoGalleryDetailPickButtonView!
    @IBOutlet weak private var detailRatingView: PhotoGalleryDetailRatingView!
    @IBOutlet weak private var detailInformationView: PhotoGalleryDetailInformationView!

    @IBOutlet weak private var relatedCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var relatedCollectionView: UICollectionView!
    @IBOutlet weak private var relatedErrorView: PhotoGalleryRelatedErrorView!

    @IBOutlet weak private var imageSlideHeightConstraint: NSLayoutConstraint!

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupRelatedContentsBlockViews()
        setupDetailPhotoBlockViews()
        setupNotificationsForDataBinding()
        setupPageViewControllers()
    }

    // MARK: - Function

    func setTargetPhoto(_ photo: PhotoEntity) {
        targetPhotoEntity = photo
        targetId = photo.id
    }

    // MARK: - Private Function

    // ナビゲーションバーに関する初期設定をする
    private func setupNavigationBar() {
        setupNavigationBarTitle("グルメ写真詳細サンプル")
    }

    // DataBindingを実行するための通知に関する初期設定をする
    private func setupNotificationsForDataBinding() {
        notificationCenter.addObserver(
            self,
            selector: #selector(self.updateStateForDetailSuccess),
            name: viewModel.successFetchPhotoDetail,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(self.updateStateForDetailFailure),
            name: viewModel.failureFetchPhotoDetail,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(self.updateStateForRecommendSuccess),
            name: viewModel.successFetchRecommendPhotoList,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(self.updateStateForRecommendFailure),
            name: viewModel.failureFetchRecommendPhotoList,
            object: nil
        )
        viewModel.fetchDetailPhotoBy(targetId: targetId)
        viewModel.fetchRecommendPhotoList()
    }

    // UICollectionViewに関する初期設定をする
    private func setupRelatedContentsBlockViews() {

        // ライブラリ「WaterfallLayout」のインスタンスを作成して設定を適用する
        let layout = WaterfallLayout()
        layout.delegate = self
        layout.sectionInset = UIEdgeInsets(top: 8.0, left: 10.0, bottom: 8.0, right: 10.0)
        layout.minimumLineSpacing = 8.0
        layout.minimumInteritemSpacing = 8.0
        layout.headerHeight = 0.0
        relatedCollectionView.setCollectionViewLayout(layout, animated: true)
        relatedCollectionView.collectionViewLayout = layout

        // 表示用のUICollectionViewを設定する
        relatedCollectionView.isScrollEnabled = false
        relatedCollectionView.registerCustomCell(PhotoGalleryCollectionViewCell.self)
        relatedCollectionView.dataSource = self
        relatedCollectionView.delegate = self
        
        // 表示用のUICollectionViewの初期高さ制約を0にしておく
        relatedCollectionViewHeightConstraint.constant = 0
        
        // エラー発生時のViewに関する初期設定
        relatedErrorView.isHidden = true
        relatedErrorView.retryRecommendButtonAction = {
            self.viewModel.fetchDetailPhotoBy(targetId: self.targetId)
            self.viewModel.fetchRecommendPhotoList()
        }
    }

    // 写真の詳細情報に関するViewの初期設定をする
    private func setupDetailPhotoBlockViews() {
        detailPickButtonView.pickPhotoButtonAction = {
            print("ボタンアクションの発火")
        }
        detailPickButtonView.changeState(isPicked: false)
        reloadDetailPhotoBlockViews()
    }

    // 写真表示用のPageViewControllerに関する初期設定をする
    private func setupPageViewControllers() {

        targetPhotosUrls = [
            targetPhotoEntity?.imageUrl,

            // MEMO: UIPageViewControllerを利用することで複数画像でもある程度対応できるようにする
            //Constants.adImageUrl1,
            //Constants.adImageUrl2,
        ]

        let _ = targetPhotosUrls.enumerated().map{
            
            // UIPageViewControllerで表示したいViewControllerの一覧を取得する
            let sb = UIStoryboard(name: "Detail", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "DetailPhotoPageViewController") as! DetailPhotoPageViewController

            // ページングして表示させるViewControllerを保持する配列へ追加する
            vc.view.tag = $0
            vc.setPhoto($1)
            photoPageViewControllers.append(vc)
        }

        // ContainerViewにEmbedしたUIPageViewControllerを取得する
        let _ = children.map {
            if let targetVC = $0 as? UIPageViewController {
                pageViewController = targetVC
            }
        }

        // UIPageViewControllerDelegate & UIPageViewControllerDataSourceの宣言
        pageViewController!.delegate = self
        pageViewController!.dataSource = self

        // PageControlの初期設定をする
        detailPhotoPageControl.isUserInteractionEnabled = false
        detailPhotoPageControl.numberOfPages = targetPhotosUrls.count
        detailPhotoPageControl.isHidden = (targetPhotosUrls.count <= 1)

        // サムネイルの高さに合わせた画像の表示エリアを設定する
        // MEMO: アスペクト比を写真表示用のUIPageViewControllerに合わせる場合は下記の対応をする
        // 修正1. DetailPhotoPageViewControllerのUIImageViewのContentModeを「AspectFit」に修正する
        // 修正2. 高さを合わせる「initializeImageSlideHeight(index: 0)」を実行しないようにする
        initializeImageSlideHeight(index: 0)

        // UIPageViewController内のUIScrollViewに対して処理をする
        let _ = pageViewController!.view.subviews.map {
            if let scrollView = $0 as? UIScrollView {
                // UIPageViewControllerでスワイプの切り替えをしないようにする
                scrollView.isScrollEnabled = (targetPhotosUrls.count > 1)
            }
        }

        // MEMO: 表示タイプはInterfaceBuilderでスクロールを設定する
        pageViewController!.setViewControllers([photoPageViewControllers[0]], direction: .forward, animated: false, completion: nil)
    }

    // 配置した写真詳細画面を構成するViewの表示をリロードする
    private func reloadDetailPhotoBlockViews() {
        if let photo = targetPhotoEntity {
            detailRatingView.setRating(photo)
            detailInformationView.setText(photo)
        }
    }

    // 配置したUICollectionViewの表示をリロードする
    private func reloadRelatedContentsCollectionView() {
        relatedCollectionView.reloadData()
        relatedCollectionView.performBatchUpdates({
            self.relatedCollectionViewHeightConstraint.constant = self.relatedCollectionView.contentSize.height
        })
    }

    // アイキャッチ画像の高さに合わせて写真エリアを調節する
    private func initializeImageSlideHeight(index: Int) {

        // 実際の写真サイズから縦幅を調整する
        var height: CGFloat = 180.0
        if let imageUrl = targetPhotosUrls[index] {
            do {
                let data = try Data(contentsOf: imageUrl)
                let image = UIImage(data: data)
                if let image = image {
                    let ratio = UIScreen.main.bounds.width / image.size.width
                    height = image.size.height * ratio
                    
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }

        // 変更したAutoLayout値を反映する
        imageSlideHeightConstraint.constant = height
        self.view.layoutIfNeeded()
    }
}

// MARK: - UIPageViewControllerDelegate, UIPageViewControllerDataSource

extension DetailContentsViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    // ページが動いたタイミング（この場合はスワイプアニメーションに該当）に発動する処理を記載する
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        // スワイプアニメーションが完了していない時には処理をさせなくする
        if !completed { return }
        
        // ここから先はUIPageViewControllerのスワイプアニメーション完了時に発動する
        if let targetVCList = pageViewController.viewControllers {
            if let targetVC = targetVCList.last {

                // 受け取ったインデックス値を元にコンテンツ表示を更新する
                detailPhotoPageControl.currentPage = targetVC.view.tag
            }
        }
    }
    
    // 逆方向にページ送りした時に呼ばれるメソッド
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        // インデックスを取得する
        guard let index = photoPageViewControllers.index(of: viewController) else {
            return nil
        }

        // インデックスの値に応じてコンテンツを動かす
        if index <= 0 {
            return nil
        } else {
            return photoPageViewControllers[index - 1]
        }
    }

    // 順方向にページ送りした時に呼ばれるメソッド
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        // インデックスを取得する
        guard let index = photoPageViewControllers.index(of: viewController) else {
            return nil
        }

        // インデックスの値に応じてコンテンツを動かす
        if index >= photoPageViewControllers.count - 1 {
            return nil
        } else {
            return photoPageViewControllers[index + 1]
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension DetailContentsViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    // 配置対象のセクションの個数を設定する
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    // 配置対象のセクションに配置するセルの個数を設定する
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return targetRecommendPhotos.count
    }
    
    // 配置対象のセクション配置するセル要素を設定する
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCustomCell(with: PhotoGalleryCollectionViewCell.self, indexPath: indexPath)
        cell.setCellDisplayData(targetRecommendPhotos[indexPath.row])
        return cell
    }
}

// MARK: - WaterfallLayoutDelegate

extension DetailContentsViewController: WaterfallLayoutDelegate {
    
    // ライブラリ「WaterfallLayout」における配置対象のセルのサイズを指定する
    func collectionView(_ collectionView: UICollectionView, layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        // セルのサイズ調整用の値
        let adjustRation: CGFloat = 2.6
        let cellWidth: CGFloat = UIScreen.main.bounds.width / 2.0
        var cellHeight: CGFloat = 120

        // 取得した画像を元に高さの調節を行う
        let targetPhoto = targetRecommendPhotos[indexPath.row]
        if let imageUrl = targetPhoto.imageUrl {
            do {
                let data = try Data(contentsOf: imageUrl)
                let image = UIImage(data: data)
                let height = image?.size.height ?? 0
                cellHeight += height / adjustRation
            } catch let error {
                print(error.localizedDescription)
            }
        }
        return CGSize(width: cellWidth, height: cellHeight)
    }

    // ライブラリ「WaterfallLayout」における配置対象のセル表示パターンを指定する
    func collectionViewLayout(for section: Int) -> WaterfallLayout.Layout {
        return .waterfall(column: 2, distributionMethod: .balanced)
    }
}

// MARK: - DetailContentsViewController

extension DetailContentsViewController {
    
    // MARK: - Function

    // 詳細表示用の写真データ取得成功の通知を受信した際に実行される処理
    @objc func updateStateForDetailSuccess(notification: Notification) {
        targetPhotoEntity = state.getTargetPhoto()
        reloadDetailPhotoBlockViews()
    }

    // 詳細表示用の写真データ取得失敗の通知を受信した際に実行される処理
    @objc func updateStateForDetailFailure(notification: Notification) {
        reloadDetailPhotoBlockViews()
    }

    // おすすめ表示用の写真データ取得成功の通知を受信した際に実行される処理
    @objc func updateStateForRecommendSuccess(notification: Notification) {
        relatedErrorView.isHidden = true
        targetRecommendPhotos = state.getRecommendPhotos()
    }
    
    // おすすめ表示用の写真データ取得失敗の通知を受信した際に実行される処理
    @objc func updateStateForRecommendFailure(notification: Notification) {
        relatedErrorView.isHidden = false
        targetRecommendPhotos = []
    }
}
