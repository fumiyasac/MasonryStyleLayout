//
//  PhotoGalleryDetailState.swift
//  MasonryStyleLayout
//
//  Created by 酒井文也 on 2019/01/24.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation

protocol PhotoGalleryDetailStateProtocol {
    func getTargetPhoto() -> PhotoEntity?
    func getRecommendPhotos() -> [PhotoEntity]
    func appendTargetPhoto(_ targetPhoto: PhotoEntity)
    func appendRecommendPhotos(_ targetPhotos: [PhotoEntity])
}

// MEMO: 取得したデータを一時的に保持するためのクラス
// ※ こちらは特にSingletonにする必要はないと判断しました。

class PhotoGalleryDetailState: PhotoGalleryDetailStateProtocol {

    // 詳細データ表示対象として利用するためのEntity
    private var storedTargetphoto: PhotoEntity?

    // 写真データとして利用するためのEntity
    private var storedRecommendPhotos: [PhotoEntity] = []

    func getTargetPhoto() -> PhotoEntity? {
        return storedTargetphoto
    }

    func getRecommendPhotos() -> [PhotoEntity] {
        return storedRecommendPhotos
    }

    func appendTargetPhoto(_ targetPhoto: PhotoEntity) {
        storedTargetphoto = targetPhoto
    }

    func appendRecommendPhotos(_ targetPhotos: [PhotoEntity]) {
        storedRecommendPhotos = targetPhotos
    }
}
