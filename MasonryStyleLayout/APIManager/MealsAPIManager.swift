//
//  MealsAPIManager.swift
//  MasonryStyleLayout
//
//  Created by 酒井文也 on 2019/01/08.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import PromiseKit

protocol APIManagerProtocol {
    func getMealList(perPage: Int) -> Promise<JSON>
    func getMealBy(id: Int) -> Promise<JSON>

    //func searchMealBy(keywords: String) -> Promise<JSON>
    //func getRecommendMealsBy(id: String) -> Promise<JSON>
}

class MealsAPIManager: APIManagerProtocol {

    // MEMO: MockサーバーへのURL
    private static let serverUrl = "http://localhost:3000/api/mock/v1/meals/"

    // MEMO: 仮のUserAgent
    private static let bundleIdentifier = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
    private static let requestHeader = [
        "User-Agent" : bundleIdentifier,
        "Content-Type" : "application/x-www-from-urlencoded"
    ]

    // MARK: - Singleton Instance

    static let shared = MealsAPIManager()

    private init() {}

    // MARK: - Enum

    // エンドポイントの定義
    private enum EndPoint {
        case list
        case search
        case detail
        case recommend

        func getPath() -> String {
            switch self {
            case .list:
                return "list"
            case .search:
                return "search"
            case .detail:
                return "detail/"
            case .recommend:
                return "recommend/"
            }
        }
    }

    // MARK: - Function

    // Alamofireの非同期通信をPromiseKitの処理でラッピングする
    // 例.
    // -----------
    // getNewsList(page: 0)
    //    .done { json in
    //        // 受け取ったJSONに関する処理をする
    //        print(json)
    //    }
    //    .catch { error in
    //        // エラーを受け取った際の処理をする
    //        print(error.localizedDescription)
    //    }
    // -----------
    // 参考URL:
    // https://medium.com/@guerrix/101-alamofire-promisekit-671436726ff6
    // ※ Swift4.1以降では書き方が変わっているのでご注意を!
    // https://stackoverflow.com/questions/48932536/swift4-error-cannot-convert-value-of-type-void-to-expected-argument-typ

    // 食事メニュー一覧を取得する
    func getMealList(perPage: Int) -> Promise<JSON> {

        let requestUrl = MealsAPIManager.serverUrl + EndPoint.list.getPath()

        // TODO: 設定するパラメーターは下記の通り
        // (page) ページ番号
        let parameters: [String : Any] = [:]

        return MealsAPIManager.handleMealsApiRequest(url: requestUrl, params: parameters)
    }

    // 引数のIDに紐づく食事メニューを取得する
    func getMealBy(id: Int) -> Promise<JSON> {

        let requestUrl = MealsAPIManager.serverUrl + EndPoint.detail.getPath() + String(id)

        return MealsAPIManager.handleMealsApiRequest(url: requestUrl)
    }

    //func searchMealBy(keywords: String) -> Promise<JSON> {}
    //func getRecommendMealsBy(id: String) -> Promise<JSON> {}

    // MARK: - Private Function

    // Promise型のデータを返却するための共通処理
    private class func handleMealsApiRequest(url: String, params: [String : Any] = [:]) -> Promise<JSON> {

        return Promise { seal in
            Alamofire.request(url, method: .get, parameters: params, encoding: JSONEncoding.default, headers: MealsAPIManager.requestHeader).validate().responseJSON { response in

                switch response.result {

                // 成功時の処理(表示に必要な部分だけを抜き出して返す)
                case .success(let response):
                    let json = JSON(response)
                    seal.fulfill(json)

                // 失敗時の処理(エラーの結果をそのまま返す)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
}
