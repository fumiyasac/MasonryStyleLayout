//
//  PhotoGalleryListViewModel.swift
//  MasonryStyleLayout
//
//  Created by 酒井文也 on 2019/01/11.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation
import SwiftyJSON

final class PhotoGalleryListViewModel {

    // ViewController側で受信できるNotification名を定義する
    let isFetchingPhotoList = Notification.Name(ViewModelNotification.isFetchingPhotoList.rawValue)
    let successFetchPhotoList = Notification.Name(ViewModelNotification.successFetchPhotoList.rawValue)
    let failureFetchPhotoList = Notification.Name(ViewModelNotification.failureFetchPhotoList.rawValue)
    let resetPhotoList = Notification.Name(ViewModelNotification.resetPhotoList.rawValue)

    // 初期化時に外部から渡されるインスタンス
    private let notificationCenter: NotificationCenter
    private let state: PhotoGalleryListStateProtocol
    private let api: APIManagerProtocol

    // MARK: - Enum

    private enum ViewModelNotification: String {
        case isFetchingPhotoList = "IsFetchingPhotoList"
        case successFetchPhotoList = "SuccessFetchPhotoList"
        case failureFetchPhotoList = "FailureFetchPhotoList"
        case resetPhotoList = "ResetPhotoList"
    }

    // MARK: - Initializer

    init(notificationCenter: NotificationCenter, state: PhotoGalleryListStateProtocol, api: APIManagerProtocol) {
        self.notificationCenter = notificationCenter
        self.state = state
        self.api = api
    }

    // MARK: - Function

    func fetchPhotoList()  {

        // データ取得処理実行中のNotification送信
        notificationCenter.post(name: isFetchingPhotoList, object: nil)

        // 合計数に到達したなら以降の作業を実行しない
        if state.isTotalCount {
            self.notificationCenter.post(name: self.successFetchPhotoList, object: nil)
            return
        }

        // 写真データをAPIから取得する(一覧表示用)
        let targetPage = state.currentPage + 1
        api.getMealList(perPage: targetPage)
            .done{ json in

                // データ保持用のStateクラスのインスタンスへ格納する
                let responseResult = self.parseJSON(json)
                print(responseResult)
                self.state.appendNextPhotos(responseResult.mealPhotoList, hasNextPage: responseResult.hasNextPage)

                // データ取得処理成功時のNotification送信
                self.notificationCenter.post(name: self.successFetchPhotoList, object: nil)
            }
            .catch { error in

                // データ取得処理失敗時のNotification送信
                self.notificationCenter.post(name: self.failureFetchPhotoList, object: nil)
                print(error.localizedDescription)
            }
    }

    // MARK: - Private Function

    // MEMO: 取得できたJSONを元にStateへ格納するためのデータを生成する

    private func parseJSON(_ json: JSON) -> (mealPhotoList: [PhotoEntity], hasNextPage: Bool) {
        let hasNextPage   = json[0]["has_next_page"].boolValue
        let mealPhotoList = json[0]["meals"].map{ PhotoEntity($1) }
        return (mealPhotoList: mealPhotoList, hasNextPage: hasNextPage)
    }
}
