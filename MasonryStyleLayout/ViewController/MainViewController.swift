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
        mainCollectionView.registerCustomCell(PhotoGalleryCollectionViewCell.self)
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
    }
}

// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {}

// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
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
