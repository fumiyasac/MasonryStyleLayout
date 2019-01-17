//
//  PhotoGalleryListState.swift
//  MasonryStyleLayout
//
//  Created by 酒井文也 on 2019/01/11.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation

// MEMO: 取得したデータを一時的に保持するためのクラス
// ※ 邪道ではあるがReduxで利用するStateのように振る舞わせるための対策

class PhotoGalleryListState {

    private let itemsPerPageCount: Int = 10

    // APIから取得したデータを一時的に格納するための変数
    // Singletonなインスタンスではあるが基本的には読み取り専用としたい　→ 「private (set)var」or「Computed Property」として保持する

    // 写真データとして利用するためのEntity
    private var photos: [PhotoEntity] = []

    // 総数に到達したかを判定するフラグ
    private (set)var isTotalCount: Bool = false

    // 現在のページ位置
    var currentPage: Int {
        return Int(ceil(Double(photos.count) / Double(itemsPerPageCount)))
    }

    // MARK: - Singleton Instance

    static let shared = PhotoGalleryListState()

    private init() {}

    // MARK: - Function

    func getPhotoListMappedByCategories() -> [(categoryNumber: Int, photos: [PhotoEntity])] {

        // MEMO: PhotoEntityの配列いおいてカテゴリ番号のプロパティ(categoryNumber)一覧の配列データを重複を除いた形にして取得する
        let targetcategoryNumbers = NSOrderedSet(array: photos.map{ $0.categoryNumber }).array as! [Int]

        // MEMO: 引数に合わせたデータ形式に変換したものを生成する
        return targetcategoryNumbers.map {
            let targetcategoryNumber = $0
            let targetPhotos = photos.filter{ targetcategoryNumber == $0.categoryNumber }.map{ $0 }
            return (categoryNumber: targetcategoryNumber, photos: targetPhotos)
        }
    }

    // APIより取得した情報をこのインスタンスのプロパティへ格納する
    func appendNextPhotos(_ targetPhotos: [PhotoEntity], hasNextPage: Bool) {

        // JSON経由で取得したデータをセットする
        isTotalCount = !hasNextPage
        let _ = targetPhotos.map{ photos.append($0) }
    }

    // このインスタンスのプロパティを初期状態へ戻す
    func resetCurrentState() {
        photos.removeAll()
        isTotalCount = false
    }
}
