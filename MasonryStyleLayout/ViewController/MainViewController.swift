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

    @IBOutlet weak private var mainCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNotificationsForDataBinding()
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
}

extension MainViewController {

    // MARK: - Function

    @objc func updateStateForFetching(notification: Notification) {
        print("updateStateForFetching:")
    }

    @objc func updateStateForSuccess(notification: Notification) {
        print("updateStateForSuccess:")
        print(PhotoGalleryDataObjectManager.shared.photos)
    }

    @objc func updateStateForFailure(notification: Notification) {
        print("updateStateForFailure:")
    }
}
