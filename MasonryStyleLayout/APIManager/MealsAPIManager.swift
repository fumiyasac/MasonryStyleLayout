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
    func getRecommendMeals() -> Promise<JSON>
}

class MealsAPIManager: APIManagerProtocol {

    // MEMO: MockサーバーへのURL
    private static let serverUrl = "http://localhost:3000/api/mock/v1/meals/"

    // MEMO: 仮のUserAgent
    private static let bundleIdentifier = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
    private static let requestHeader = HTTPHeaders(
        arrayLiteral: HTTPHeader(name: "User-Agent", value: bundleIdentifier),
        HTTPHeader(name: "Content-Type", value: "application/x-www-from-urlencoded")
    )

    // MARK: - Singleton Instance

    static let shared = MealsAPIManager()

    private init() {}

    // MARK: - Enum

    // エンドポイントの定義
    private enum EndPoint {
        case list
        case detail
        case recommend

        func getPath() -> String {
            switch self {
            case .list:
                return "list/"
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
        let requestUrl = MealsAPIManager.serverUrl + EndPoint.list.getPath() + "?page=" + String(perPage)
        return MealsAPIManager.handleMealsApiRequest(url: requestUrl)
    }

    // 引数のIDに紐づく食事メニューを取得する
    func getMealBy(id: Int) -> Promise<JSON> {
        let requestUrl = MealsAPIManager.serverUrl + EndPoint.detail.getPath() + String(id)
        return MealsAPIManager.handleMealsApiRequest(url: requestUrl)
    }

    // おすすめの食事メニューを取得する
    func getRecommendMeals() -> Promise<JSON> {
        let requestUrl = MealsAPIManager.serverUrl + EndPoint.recommend.getPath()
        return MealsAPIManager.handleMealsApiRequest(url: requestUrl)
    }

    // MARK: - Private Function

    // Promise型のデータを返却するための共通処理
    private class func handleMealsApiRequest(url: String, params: [String : Any] = [:]) -> Promise<JSON> {

        return Promise { seal in
            AF.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: MealsAPIManager.requestHeader)
                .responseData { response in

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
