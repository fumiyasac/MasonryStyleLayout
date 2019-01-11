//
//  PhotoGalleryViewModel.swift
//  MasonryStyleLayout
//
//  Created by 酒井文也 on 2019/01/11.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation

final class PhotoGalleryViewModel {

    // ViewController側で受信できるNotification名を定義する
    let isFetchingPhotoList = Notification.Name(ViewModelNotification.isFetchingPhotoList.rawValue)
    let successFetchPhotoList = Notification.Name(ViewModelNotification.successFetchPhotoList.rawValue)
    let failureFetchPhotoList = Notification.Name(ViewModelNotification.failureFetchPhotoList.rawValue)
    let resetPhotoList = Notification.Name(ViewModelNotification.resetPhotoList.rawValue)

    private let notificationCenter: NotificationCenter

    private var nextPage: Int = 1

    // MARK: - Enum

    private enum ViewModelNotification: String {
        case isFetchingPhotoList = "IsFetchingPhotoList"
        case successFetchPhotoList = "SuccessFetchPhotoList"
        case failureFetchPhotoList = "FailureFetchPhotoList"
        case resetPhotoList = "ResetPhotoList"
    }

    // MARK: - Initializer

    init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
    }

    // MARK: - Function

    // 写真データをAPIから取得する
    func fetchPhotoList()  {

        // データ取得処理実行中のNotification送信
        notificationCenter.post(name: isFetchingPhotoList, object: nil)

        MealsAPIManager.shared.getMealList(perPage: nextPage)
            .done{ json in

                // データ保持用のインスタンスへ格納する
                let hasNextPage = json["has_next_page"].boolValue
                let mealPhotoList = json["meals"].map{ (_, targetJSON) in
                    return PhotoEntity(targetJSON)
                }
                PhotoGalleryDataObjectManager.shared.appendNextPhotos(mealPhotoList, hasNextPage: hasNextPage)

                // データ取得処理成功時のNotification送信
                self.nextPage = PhotoGalleryDataObjectManager.shared.currentPage
                self.notificationCenter.post(name: self.successFetchPhotoList, object: nil)
            }
            .catch { error in

                // データ取得処理失敗時のNotification送信
                self.notificationCenter.post(name: self.failureFetchPhotoList, object: nil)
                print(error.localizedDescription)
            }
    }
}
