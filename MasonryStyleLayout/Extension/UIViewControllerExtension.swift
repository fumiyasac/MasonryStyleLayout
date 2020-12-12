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
        attributes[NSAttributedString.Key.foregroundColor] = UIColor.white

        // NavigationControllerの配色に関するデザイン調整を行う
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.titleTextAttributes = attributes

        // タイトルを入れる
        self.navigationItem.title = title
    }

    // 戻るボタンの「戻る」テキストを削除した状態にするメソッド
    func removeBackButtonText() {
        // MEMO: NavigationBarのBackボタン長押し時にタイトルを表示するためにiOS14.0以上とそれ以外での条件分岐をする
        // 参考: https://speakerdeck.com/daichikuwa0618/towards-ios-14-in-yumemi-dot-inc
        self.navigationController!.navigationBar.tintColor = UIColor.white
        if #available(iOS 14.0, *) {
            self.navigationItem.backButtonDisplayMode = .minimal
            self.navigationItem.backButtonTitle = self.navigationItem.title
        } else {
            let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButtonItem
        }
    }
}

