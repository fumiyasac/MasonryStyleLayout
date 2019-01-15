//
//  PhotoGalleryViewModel.swift
//  MasonryStyleLayout
//
//  Created by 酒井文也 on 2019/01/11.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation
import SwiftyJSON

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

                // データ保持用のStateクラスのインスタンスへ格納する
                let responseResult = self.parseJSON(json)
                print(responseResult)
                PhotoGalleryListState.shared.appendNextPhotos(responseResult.mealPhotoList, hasNextPage: responseResult.hasNextPage)

                // データ取得処理成功時のNotification送信
                self.nextPage = PhotoGalleryListState.shared.currentPage
                self.notificationCenter.post(name: self.successFetchPhotoList, object: nil)
            }
            .catch { error in

                // データ取得処理失敗時のNotification送信
                self.notificationCenter.post(name: self.failureFetchPhotoList, object: nil)
                print(error.localizedDescription)
            }
    }

    // MARK: - Private Function

    private func parseJSON(_ json: JSON) -> (mealPhotoList: [PhotoEntity], hasNextPage: Bool) {

        // 取得できたJSONを元にStateへ格納するためのデータを生成する
        let hasNextPage   = json["has_next_page"].boolValue
        let mealPhotoList = json["meals"].map{ PhotoEntity($1) }
        return (mealPhotoList: mealPhotoList, hasNextPage: hasNextPage)
    }
}
