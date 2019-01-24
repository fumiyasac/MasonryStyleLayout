//
//  PhotoGalleryDetailViewModel.swift
//  MasonryStyleLayout
//
//  Created by 酒井文也 on 2019/01/24.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation
import SwiftyJSON

final class PhotoGalleryDetailViewModel {

    // ViewController側で受信できるNotification名を定義する
    let successFetchPhotoDetail = Notification.Name(ViewModelNotification.successFetchPhotoDetail.rawValue)
    let failureFetchPhotoDetail = Notification.Name(ViewModelNotification.failureFetchPhotoDetail.rawValue)
    let successFetchRecommendPhotoList = Notification.Name(ViewModelNotification.successFetchRecommendPhotoList.rawValue)
    let failureFetchRecommendPhotoList = Notification.Name(ViewModelNotification.failureFetchRecommendPhotoList.rawValue)

    // 初期化時に外部から渡されるインスタンス
    private let notificationCenter: NotificationCenter
    private let state: PhotoGalleryDetailStateProtocol
    private let api: APIManagerProtocol

    // MARK: - Enum

    private enum ViewModelNotification: String {
        case successFetchPhotoDetail = "SuccessFetchPhotoDetail"
        case failureFetchPhotoDetail = "FailureFetchPhotoDetail"
        case successFetchRecommendPhotoList = "SuccessFetchRecommendPhotoList"
        case failureFetchRecommendPhotoList = "FailureFetchRecommendPhotoList"
    }

    // MARK: - Initializer

    init(notificationCenter: NotificationCenter, state: PhotoGalleryDetailStateProtocol, api: APIManagerProtocol) {
        self.notificationCenter = notificationCenter
        self.state = state
        self.api = api
    }

    // MARK: - Function

    func fetchDetailPhotoBy(targetId: Int)  {

        // 写真データをAPIから取得する(詳細表示用)
        api.getMealBy(id: targetId)
            .done{ json in

                // データ保持用のStateクラスのインスタンスへ格納する
                let responseResult = self.parseJSONForDetail(json)
                print(responseResult)
                self.state.appendTargetPhoto(responseResult)

                // データ取得処理成功時のNotification送信
                self.notificationCenter.post(name: self.successFetchPhotoDetail, object: nil)
            }
            .catch { error in

                // データ取得処理失敗時のNotification送信
                self.notificationCenter.post(name: self.failureFetchPhotoDetail, object: nil)
                print(error.localizedDescription)
        }
    }

    func fetchRecommendPhotoList()  {

        // 写真データをAPIから取得する(おすすめ表示用)
        api.getRecommendMeals()
            .done{ json in

                // データ保持用のStateクラスのインスタンスへ格納する
                let responseResult = self.parseJSONForRecommend(json)
                print(responseResult)
                self.state.appendRecommendPhotos(responseResult)

                // データ取得処理成功時のNotification送信
                self.notificationCenter.post(name: self.successFetchRecommendPhotoList, object: nil)
            }
            .catch { error in

                // データ取得処理失敗時のNotification送信
                self.notificationCenter.post(name: self.failureFetchRecommendPhotoList, object: nil)
                print(error.localizedDescription)
        }
    }

    // MARK: - Private Function

    // MEMO: 取得できたJSONを元にStateへ格納するためのデータを生成する

    private func parseJSONForDetail(_ json: JSON) -> PhotoEntity {
        return PhotoEntity(json)
    }

    private func parseJSONForRecommend(_ json: JSON) -> [PhotoEntity] {
        return json[0]["meals"].map{ PhotoEntity($1) }
    }
}
