//
//  MockPhotoGalleryListState.swift
//  MasonryStyleLayoutTests
//
//  Created by 酒井文也 on 2019/01/21.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation

@testable import MasonryStyleLayout

class MockPhotoGalleryListState: PhotoGalleryListStateProtocol {

    private let itemsPerPageCount: Int = 10

    // 写真データとして利用するためのEntity
    private var photos: [PhotoEntity] = []

    // 総数に到達したかを判定するフラグ
    private (set)var isTotalCount: Bool = false

    // 現在のページ位置
    var currentPage: Int {
        return Int(ceil(Double(photos.count) / Double(itemsPerPageCount)))
    }

    // MARK: - Singleton Instance

    static let shared = MockPhotoGalleryListState()

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
