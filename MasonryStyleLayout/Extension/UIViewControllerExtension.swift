//
//  UIViewControllerExtension.swift
//  MasonryStyleLayout
//
//  Created by 酒井文也 on 2019/01/18.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation
import UIKit

// UIViewControllerの拡張
extension UIViewController {

    // この画面のナビゲーションバーを設定するメソッド
    func setupNavigationBarTitle(_ title: String) {

        // NavigationControllerのフォントに関するデザイン調整を行う
        var attributes = [NSAttributedString.Key : Any]()
        attributes[NSAttributedString.Key.font] = UIFont(name: "HiraKakuProN-W6", size: 14.0)
        attributes[NSAttributedString.Key.foregroundColor]  = UIColor.white

        // NavigationControllerの配色に関するデザイン調整を行う
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.titleTextAttributes = attributes

        // タイトルを入れる
        self.navigationItem.title = title
    }

    // 戻るボタンの「戻る」テキストを削除した状態にするメソッド
    func removeBackButtonText() {
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationItem.backBarButtonItem = backButtonItem
    }
}

