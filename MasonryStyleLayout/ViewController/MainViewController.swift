//
//  MainViewController.swift
//  MasonryStyleLayout
//
//  Created by 酒井文也 on 2019/01/07.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var mainCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // MEMO: APIからの取得テスト

        // (その1) データの一覧を取得するテスト
        MealsAPIManager.shared.getMealList(perPage: 0)
            .done{ json in
                // 受け取ったJSONに関する処理をする
                print(json)
            }
            .catch { error in
                // エラーを受け取った際の処理をする
                print(error.localizedDescription)
            }

        // (その2) ID指定のデータを取得するテスト
        MealsAPIManager.shared.getMealBy(id: 1)
            .done { json in
                // 受け取ったJSONに関する処理をする
                print(json)
            }
            .catch { error in
                // エラーを受け取った際の処理をする
                print(error.localizedDescription)
            }
    }
}
