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

final class MainViewController: UIViewController {

    private let notificationCenter = NotificationCenter()
    private lazy var viewModel = PhotoGalleryViewModel(notificationCenter: notificationCenter)

    // MEMO: プロパティの変更タイミングに応じてCollectionViewの更新を実行する
    private var photoGalleryLists: [PhotoEntity] = [] {
        didSet {
            self.mainCollectionView.reloadData()
        }
    }

    @IBOutlet weak private var mainCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNotificationsForDataBinding()
        setupMainCollectionView()
    }

    // MARK: - Private Function

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
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8.0, bottom: 8.0, right: 8.0)
        layout.minimumLineSpacing = 8.0
        layout.minimumInteritemSpacing = 8.0
        layout.headerHeight = 58.0
        mainCollectionView.setCollectionViewLayout(layout, animated: true)
        mainCollectionView.collectionViewLayout = layout

        // 表示用のUICollectionViewを設定する
        mainCollectionView.registerCustomReusableHeaderView(PhotoGalleryCollectionHeaderView.self)
        mainCollectionView.registerCustomCell(PhotoGalleryCollectionViewCell.self)
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    // セクションの個数を設定する
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    // 配置するUICollectionReusableViewのサイズを設定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        return PhotoGalleryCollectionHeaderView.viewSize
    }

    // 配置するUICollectionReusableViewの設定する
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let shouldDisplayHeader = (kind == UICollectionView.elementKindSectionHeader)
        if shouldDisplayHeader {
            let header = collectionView.dequeueReusableCustomHeaderView(with: PhotoGalleryCollectionHeaderView.self, indexPath: indexPath)
            return header
        } else {
            return UICollectionReusableView()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoGalleryLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCustomCell(with: PhotoGalleryCollectionViewCell.self, indexPath: indexPath)
        let targetPhoto = photoGalleryLists[indexPath.row]
        cell.setCellDisplayData(targetPhoto)
        return cell
    }
}

// MARK: - WaterfallLayoutDelegate

extension MainViewController: WaterfallLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView, layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        // セルのサイズ調整用の値
        let adjustRation: CGFloat = 2.6
        let cellWidth: CGFloat = UIScreen.main.bounds.width / 2.0
        var cellHeight: CGFloat = 120

        // 取得した画像を元に高さの調節を行う
        let targetPhoto = photoGalleryLists[indexPath.row]
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

// MARK: - MainViewController

extension MainViewController {

    // MARK: - Function

    @objc func updateStateForFetching(notification: Notification) {
        print("updateStateForFetching:")
    }

    @objc func updateStateForSuccess(notification: Notification) {
        print("updateStateForSuccess:")
        print(PhotoGalleryListState.shared.photos)
        photoGalleryLists = PhotoGalleryListState.shared.photos
    }

    @objc func updateStateForFailure(notification: Notification) {
        print("updateStateForFailure:")
    }
}
