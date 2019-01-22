//
//  MockMealsAPIManager.swift
//  MasonryStyleLayoutTests
//
//  Created by 酒井文也 on 2019/01/21.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation
import SwiftyJSON
import PromiseKit

@testable import MasonryStyleLayout

// MEMO: APIリクエストのMock用のクラス
// PromiseKitでラッピングしているAPI通信処理をBundleされているJSONファイルの読み込みへ置き換える

class MockMealsAPIManager: APIManagerProtocol {

    // MARK: - Singleton Instance

    static let shared = MockMealsAPIManager()

    private init() {}
    
    // MARK: - Function

    // 食事メニュー一覧を取得する
    func getMealList(perPage: Int) -> Promise<JSON> {
        if let path = getStubFilePath(jsonFileName: "page\(perPage)") {
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            return Promise { seal in
                seal.fulfill(JSON(data))
            }
        } else {
            fatalError("Invalid json format or existence of file.")
        }
    }

    // 引数のIDに紐づく食事メニューを取得する
    func getMealBy(id: Int) -> Promise<JSON> {
        if let path = getStubFilePath(jsonFileName: "detail") {
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            return Promise { seal in
                seal.fulfill(JSON(data))
            }
        } else {
            fatalError("Invalid json format or existence of file.")
        }
    }

    // MARK: - Private Function

    private func getStubFilePath(jsonFileName: String) -> String? {
        let t = type(of: self)
        let bundle = Bundle(for: t.self)
        return bundle.path(forResource: jsonFileName, ofType: "json")
    }
}
