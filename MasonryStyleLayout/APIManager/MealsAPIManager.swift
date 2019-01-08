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
    /*
    func searchMealBy(keywords: String) -> Promise<JSON>
    func getRecommendMealsBy(id: String) -> Promise<JSON>
    */
}

class MealsAPIManager: APIManagerProtocol {

    private static let SERVER_URL = "http://localhost:3000/api/mock/v1/meals/"

    // MARK: - Singleton Instance

    static let shared = MealsAPIManager()

    private init() {}

    // MARK: - Enum

    private enum EndPoint {
        case list
        case detail
        case search
        case recommend

        func getPath() -> String {
            switch self {
            case .list:
                return "list"
            case .detail:
                return "detail/"
            case .search:
                return "search"
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

    func getMealList(perPage: Int) -> Promise<JSON> {

        let baseUri = MealsAPIManager.SERVER_URL + EndPoint.list.getPath()

        // JSON Serverの定義に合わせたfilter条件を定義する
        // (参考) https://github.com/typicode/json-server
        // 設定するパラメーター:
        // page: ページ番号
        let parameters: [String : Any] = [:]

        return Promise { seal in
            Alamofire.request(baseUri, method: .get, parameters: parameters).validate().responseJSON { response in

                switch response.result {

                // 成功時の処理(表示に必要な部分だけを抜き出して返す)
                case .success(let response):
                    let json = JSON(response)
                    seal.fulfill(json["meals"])

                // 失敗時の処理(エラーの結果をそのまま返す)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }

    func getMealBy(id: Int) -> Promise<JSON> {

        let baseUri = MealsAPIManager.SERVER_URL + EndPoint.detail.getPath() + String(id)

        return Promise { seal in
            Alamofire.request(baseUri, method: .get, parameters: [:]).validate().responseJSON { response in

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

    /*
    func searchMealBy(keywords: String) -> Promise<JSON> {}

    func getRecommendMealsBy(id: String) -> Promise<JSON> {}
    */
}
