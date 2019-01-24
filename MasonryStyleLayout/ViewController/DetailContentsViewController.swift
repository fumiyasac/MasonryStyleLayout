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

    // ViewModelの初期化
    private lazy var viewModel = PhotoGalleryDetailViewModel(notificationCenter: notificationCenter, state: state, api: api)

    @IBOutlet weak private var detailPhotoCountainer: UIView!
    @IBOutlet weak private var detailPhotoPageControl: UIPageControl!

    @IBOutlet weak private var detailPickButtonView: PhotoGalleryDetailPickButtonView!
    @IBOutlet weak private var detailRatingView: PhotoGalleryDetailRatingView!
    @IBOutlet weak private var detailInformationView: PhotoGalleryDetailInformationView!

    @IBOutlet weak private var relatedCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var relatedCollectionView: UICollectionView!
    @IBOutlet weak private var relatedErrorView: PhotoGalleryRelatedErrorView!

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupRelatedContentsBlockViews()
        setupDetailPhotoBlockViews()
        setupNotificationsForDataBinding()
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
            selector: #selector(self.updateStateForDetailFetching),
            name: viewModel.isFetchingPhotoDetail,
            object: nil
        )
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
            selector: #selector(self.updateStateForRecommendFetching),
            name: viewModel.isFetchingRecommendPhotoList,
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
        relatedCollectionViewHeightConstraint.constant = relatedCollectionView.contentSize.height
        
        // エラー発生時のViewに関する初期設定
        relatedErrorView.isHidden = true
        relatedErrorView.retryRecommendButtonAction = {
            self.viewModel.fetchDetailPhotoBy(targetId: self.targetId)
            self.viewModel.fetchRecommendPhotoList()
        }
    }
    
    private func setupDetailPhotoBlockViews() {
        detailPickButtonView.pickPhotoButtonAction = {
            print("ボタンアクションの発火")
        }
        detailPickButtonView.changeState(isPicked: false)
        reloadDetailPhotoBlockViews()
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
        if let imageURL = targetPhoto.imageUrl {
            do {
                let data = try Data(contentsOf: imageURL)
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

    // 詳細表示用の写真データ取得中の通知を受信した際に実行される処理
    @objc func updateStateForDetailFetching(notification: Notification) {
    }

    // 詳細表示用の写真データ取得成功の通知を受信した際に実行される処理
    @objc func updateStateForDetailSuccess(notification: Notification) {
        targetPhotoEntity = state.getTargetPhoto()
        reloadDetailPhotoBlockViews()
    }

    // 詳細表示用の写真データ取得失敗の通知を受信した際に実行される処理
    @objc func updateStateForDetailFailure(notification: Notification) {
        reloadDetailPhotoBlockViews()
    }

    // おすすめ表示用の写真データ取得中の通知を受信した際に実行される処理
    @objc func updateStateForRecommendFetching(notification: Notification) {
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
