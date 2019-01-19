//
//  MainViewController.swift
//  MasonryStyleLayout
//
//  Created by 酒井文也 on 2019/01/07.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import UIKit
import AlamofireImage

// MEMO: RxSwiftを利用しないMVVMパターンの利用をする
// → 書籍「iOS設計パターン入門 第6章 MVVM」で紹介されていたコードを参考に構築しました。

final class MainContentsViewController: UIViewController {

    private let notificationCenter = NotificationCenter()
    private lazy var viewModel = PhotoGalleryViewModel(notificationCenter: notificationCenter)

    // MEMO: プロパティの変更タイミングに応じてCollectionViewの更新を実行する
    private var photoGalleryLists: [(categoryNumber: Int, photos: [PhotoEntity])] = [] {
        didSet {
            self.reloadMainContentsCollectionView()
        }
    }

    @IBOutlet weak private var mainContentsCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var mainContentsCollectionView: UICollectionView!
    @IBOutlet weak private var mainContentsHandleButtonView: PhotoGalleryHandleButtonView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupNotificationsForDataBinding()
        setupMainCollectionView()
        setupMainContentsHandleButtonView()
    }

    // MARK: - Private Function

    private func setupNavigationBar() {
        setupNavigationBarTitle("グルメ写真一覧サンプル")
        removeBackButtonText()
    }

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

    private func setupMainCollectionView() {

        // WaterfallLayoutのインスタンスを作成して設定を適用する
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

    private func setupMainContentsHandleButtonView() {
        mainContentsHandleButtonView.requestApiButtonAction = {
            self.viewModel.fetchPhotoList()
        }
    }

    private func reloadMainContentsCollectionView() {
        mainContentsCollectionView.reloadData()
        mainContentsCollectionView.performBatchUpdates({
            self.mainContentsCollectionViewHeightConstraint.constant = self.mainContentsCollectionView.contentSize.height
        })
    }

    private func allowUserInterations() {
        mainContentsCollectionView.alpha = 1
        mainContentsCollectionView.isUserInteractionEnabled = true
    }

    private func denyUserInterations() {
        mainContentsCollectionView.alpha = 0.6
        mainContentsCollectionView.isUserInteractionEnabled = false
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension MainContentsViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    // セクションの個数を設定する
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return photoGalleryLists.count
    }

    // 配置するUICollectionReusableViewのサイズを設定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        return PhotoGalleryCollectionHeaderView.viewSize
    }

    // 配置するUICollectionReusableViewの設定する
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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoGalleryLists[section].photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCustomCell(with: PhotoGalleryCollectionViewCell.self, indexPath: indexPath)
        cell.setCellDisplayData(photoGalleryLists[indexPath.section].photos[indexPath.row])
        return cell
    }
}

// MARK: - WaterfallLayoutDelegate

extension MainContentsViewController: WaterfallLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView, layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        // セルのサイズ調整用の値
        let adjustRation: CGFloat = 2.6
        let cellWidth: CGFloat = UIScreen.main.bounds.width / 2.0
        var cellHeight: CGFloat = 120

        // 取得した画像を元に高さの調節を行う
        let targetPhoto = photoGalleryLists[indexPath.section].photos[indexPath.row]
        if let imageURL = targetPhoto.imageUrl {
            do {
                let data = try Data(contentsOf: imageURL)
                let image = UIImage(data: data)
                let height = image?.size.height ?? 0
                cellHeight += height / adjustRation
            } catch let error {
                print("Error occurred for getting image: ", error.localizedDescription)
            }
        }
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionViewLayout(for section: Int) -> WaterfallLayout.Layout {
        return .waterfall(column: 2, distributionMethod: .balanced)
    }
}

// MARK: - MainContentsViewController

extension MainContentsViewController {

    // MARK: - Function

    @objc func updateStateForFetching(notification: Notification) {
        print("updateStateForFetching:")

        // View描画に関わる変更
        denyUserInterations()
        mainContentsHandleButtonView.changeState(isFetchingData: true)
    }

    @objc func updateStateForSuccess(notification: Notification) {
        print("updateStateForSuccess:")

        // View描画に関わる変更
        allowUserInterations()
        mainContentsHandleButtonView.changeState(isFetchingData: false)
        mainContentsHandleButtonView.isHidden = PhotoGalleryListState.shared.isTotalCount

        // データ表示に関わる変更
        photoGalleryLists = PhotoGalleryListState.shared.getPhotoListMappedByCategories()
    }

    @objc func updateStateForFailure(notification: Notification) {
        print("updateStateForFailure:")

        // View描画に関わる変更
        allowUserInterations()
        mainContentsHandleButtonView.changeState(isFetchingData: false)
        showAlertWith(completionHandler: nil)
    }
}
