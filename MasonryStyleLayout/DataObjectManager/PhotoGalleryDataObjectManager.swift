//
//  PhotoGalleryDataObjectManager.swift
//  MasonryStyleLayout
//
//  Created by 酒井文也 on 2019/01/11.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation

// MEMO: 取得したデータを一時的に保持するためのクラス
// ※ 邪道ではあるがReduxで利用するStateのように振る舞わせるために呼び出し側では取得しか許可しない

class PhotoGalleryDataObjectManager {

    private let itemsPerPageCount: Int = 10

    // APIから取得したデータを一時的に格納するための変数
    // → 「private (set)var」or「Computed Property」として保持する

    // 写真データとして利用するためのEntity
    private (set)var photos: [PhotoEntity] = []

    // 総数に到達したかを判定するフラグ
    private (set)var isTotalCount: Bool = false

    // 現在のページ位置数
    var currentPage: Int {
        return Int(ceil(Double(photos.count) / Double(itemsPerPageCount)))
    }

    // MARK: - Singleton Instance

    static let shared = PhotoGalleryDataObjectManager()

    private init() {}

    // MARK: - Function

    func appendNextPhotos(_ targetPhotos: [PhotoEntity], hasNextPage: Bool) {

        // 次のページがあるかを判定し、なければ以降の処理を実行しない
        isTotalCount = !hasNextPage
        if isTotalCount { return }

        // JSON経由で取得したデータをセットする
        let _ = targetPhotos.map{ photos.append($0) }
    }

    func reset() {
        photos.removeAll()
        isTotalCount = false
    }

    func isEmpty() -> Bool {
        return photos.isEmpty
    }
}
