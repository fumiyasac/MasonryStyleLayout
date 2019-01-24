//
//  MainViewController.swift
//  MasonryStyleLayout
//
//  Created by 酒井文也 on 2019/01/07.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import UIKit

// MEMO: RxSwiftを利用しないMVVMパターンの利用をする
// → 書籍「iOS設計パターン入門 第6章 MVVM」で紹介されていたコードを参考に構築しました。

final class MainContentsViewController: UIViewController {

    // ViewModelの初期化に必要な要素の定義
    private let notificationCenter = NotificationCenter()
    private let state = PhotoGalleryListState.shared
    private let api = MealsAPIManager.shared

    // ViewModelの初期化
    private lazy var viewModel = PhotoGalleryListViewModel(notificationCenter: notificationCenter, state: state, api: api)

    // MEMO: プロパティの変更タイミングに応じてCollectionViewの更新を実行する
    private var photoGalleryLists: [(categoryNumber: Int, photos: [PhotoEntity])] = [] {
        didSet {
            self.reloadMainContentsCollectionView()
        }
    }

    // 表示の調整に必要なUI部品やAutoLayoutの制約
    @IBOutlet weak private var mainContentsCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var mainContentsCollectionView: UICollectionView!
    @IBOutlet weak private var mainContentsHandleButtonView: PhotoGalleryHandleButtonView!

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupNotificationsForDataBinding()
        setupMainCollectionView()
        setupMainContentsHandleButtonView()
    }

    // MARK: - Private Function

    // ナビゲーションバーに関する初期設定をする
    private func setupNavigationBar() {
        setupNavigationBarTitle("グルメ写真一覧サンプル")
        removeBackButtonText()
    }

    // DataBindingを実行するための通知に関する初期設定をする
    private func setupNotificationsForDataBinding() {
        notificationCenter.addObserver(
            self,
            selector: #selector(self.updateStateForFetching),
            name: viewModel.isFetchingPhotoList,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(self.updateStateForSuccess),
            name: viewModel.successFetchPhotoList,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(self.updateStateForFailure),
            name: viewModel.failureFetchPhotoList,
            object: nil
        )
        viewModel.fetchPhotoList()
    }

    // UICollectionViewに関する初期設定をする
    private func setupMainCollectionView() {

        // ライブラリ「WaterfallLayout」のインスタンスを作成して設定を適用する
        let layout = WaterfallLayout()
        layout.delegate = self
        layout.sectionInset = UIEdgeInsets(top: 8.0, left: 10.0, bottom: 8.0, right: 10.0)
        layout.minimumLineSpacing = 8.0
        layout.minimumInteritemSpacing = 8.0
        layout.headerHeight = 58.0
        mainContentsCollectionView.setCollectionViewLayout(layout, animated: true)
        mainContentsCollectionView.collectionViewLayout = layout

        // 表示用のUICollectionViewを設定する
        mainContentsCollectionView.isScrollEnabled = false
        mainContentsCollectionView.registerCustomReusableHeaderView(PhotoGalleryCollectionHeaderView.self)
        mainContentsCollectionView.registerCustomCell(PhotoGalleryCollectionViewCell.self)
        mainContentsCollectionView.dataSource = self
        mainContentsCollectionView.delegate = self

        // 表示用のUICollectionViewの初期高さ制約を0にしておく
        mainContentsCollectionViewHeightConstraint.constant = mainContentsCollectionView.contentSize.height
    }

    // APIリクエスト実行用ボタンを含んだViewに関する初期設定をする
    private func setupMainContentsHandleButtonView() {
        mainContentsHandleButtonView.requestApiButtonAction = {
            self.viewModel.fetchPhotoList()
        }
    }

    // 配置したUICollectionViewの表示をリロードする
    private func reloadMainContentsCollectionView() {
        mainContentsCollectionView.reloadData()
        mainContentsCollectionView.performBatchUpdates({
            self.mainContentsCollectionViewHeightConstraint.constant = self.mainContentsCollectionView.contentSize.height
        })
    }

    // この画面におけるユーザー操作を受け付けた状態にする
    private func allowUserInterations() {
        mainContentsCollectionView.alpha = 1
        mainContentsCollectionView.isUserInteractionEnabled = true
    }

    // この画面におけるユーザー操作を受け付けない状態にする
    private func denyUserInterations() {
        mainContentsCollectionView.alpha = 0.6
        mainContentsCollectionView.isUserInteractionEnabled = false
    }

    // エラー発生時のアラート表示を設定をする
    private func showAlertWith(completionHandler: (() -> ())? = nil) {
        let alert = UIAlertController(
            title: "エラーが発生しました",
            message: "APIからのデータの取得に失敗しました。通信環境等を確認の上再度お試し下さい。",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            completionHandler?()
        })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension MainContentsViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    // 配置対象のセクションの個数を設定する
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return photoGalleryLists.count
    }

    // 配置対象のセクションにおけるUICollectionReusableViewのサイズを設定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        return PhotoGalleryCollectionHeaderView.viewSize
    }

    // 配置対象のセクションにおけるUICollectionReusableViewの設定する
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader {

            // ヘッダーのインスタンスを取得する
            let header = collectionView.dequeueReusableCustomHeaderView(with: PhotoGalleryCollectionHeaderView.self, indexPath: indexPath)

            // ヘッダーに設定する文言を取得してセットする
            let targetCategoryNumber = photoGalleryLists[indexPath.section].categoryNumber
            if let categoryNumberType = CategoryNumberType(rawValue: targetCategoryNumber) {
                header.setSectionTitle(categoryNumberType.getCategoryTitle())
            }
            return header

        } else {
            return UICollectionReusableView()
        }
    }

    // 配置対象のセクションに配置するセルの個数を設定する
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoGalleryLists[section].photos.count
    }

    // 配置対象のセクション配置するセル要素を設定する
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCustomCell(with: PhotoGalleryCollectionViewCell.self, indexPath: indexPath)
        cell.setCellDisplayData(photoGalleryLists[indexPath.section].photos[indexPath.row])
        return cell
    }

    // 配置対象のセクション配置するセル要素タップ時の振る舞いを設定する
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photoGalleryLists[indexPath.section].photos[indexPath.row]
        let vc = UIStoryboard(name: "Detail", bundle: nil).instantiateInitialViewController() as! DetailContentsViewController
        vc.setTargetPhoto(photo)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - WaterfallLayoutDelegate

extension MainContentsViewController: WaterfallLayoutDelegate {

    // ライブラリ「WaterfallLayout」における配置対象のセルのサイズを指定する
    func collectionView(_ collectionView: UICollectionView, layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        // セルのサイズ調整用の値
        let adjustRation: CGFloat = 2.6
        let cellWidth: CGFloat = UIScreen.main.bounds.width / 2.0
        var cellHeight: CGFloat = 120

        // 取得した画像を元に高さの調節を行う
        let targetPhoto = photoGalleryLists[indexPath.section].photos[indexPath.row]
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

// MARK: - MainContentsViewController

extension MainContentsViewController {

    // MARK: - Function

    // 写真データ取得中の通知を受信した際に実行される処理
    @objc func updateStateForFetching(notification: Notification) {

        // View描画に関わる変更
        denyUserInterations()
        mainContentsHandleButtonView.changeState(isFetchingData: true)
    }

    // 写真データ取得成功の通知を受信した際に実行される処理
    @objc func updateStateForSuccess(notification: Notification) {

        // View描画に関わる変更
        allowUserInterations()
        mainContentsHandleButtonView.changeState(isFetchingData: false)
        mainContentsHandleButtonView.isHidden = state.isTotalCount

        // データ表示に関わる変更
        photoGalleryLists = state.getPhotoListMappedByCategories()
    }

    // 写真データ取得失敗の通知を受信した際に実行される処理
    @objc func updateStateForFailure(notification: Notification) {

        // View描画に関わる変更
        allowUserInterations()
        mainContentsHandleButtonView.changeState(isFetchingData: false)
        showAlertWith(completionHandler: nil)
    }
}
