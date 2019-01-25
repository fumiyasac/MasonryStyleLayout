//
//  GlobaTabBarController.swift
//  MasonryStyleLayout
//
//  Created by 酒井文也 on 2019/01/25.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import UIKit

class GlobaTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGlobalTabBarInitialSetting()
        setupGlobalTabBarContents()
    }

    // UITabBarControllerの初期設定に関する調整
    private func setupGlobalTabBarInitialSetting() {

        // UITabBarControllerDelegateの宣言
        self.delegate = self

        // 初期設定として空のUIViewControllerのインスタンスを追加する
        self.viewControllers = [UIViewController(), UIViewController()]
    }

    // GlobalTabBarControllerで表示したい画面に関する設定処理
    private func setupGlobalTabBarContents() {
        
        // タブの選択時・非選択時の色とアイコンのサイズを決める
        let itemSize = CGSize(width: 28.0, height: 28.0)
        let normalColor: UIColor = UIColor(code: "#aaaaaa")
        let selectedColor: UIColor = UIColor(code: "#00a6ff")
        let tabBarItemFont = UIFont(name: "HiraKakuProN-W3", size: 10)!

        // TabBar用のAttributeを決める
        let normalAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: tabBarItemFont,
            NSAttributedString.Key.foregroundColor: normalColor
        ]
        let selectedAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: tabBarItemFont,
            NSAttributedString.Key.foregroundColor: selectedColor
        ]

        // TabBarに表示する画面を決める
        let _ = TabBarItemsType.allCases.enumerated().map { (index, tabBarItem) in

            // 該当ViewControllerの設置
            guard let vc = tabBarItem.getViewController() else {
                fatalError()
            }
            self.viewControllers?[index] = vc

            // 該当ViewControllerのタイトル設置
            self.viewControllers?[index].title = tabBarItem.getTabTitle()

            // 該当ViewControllerのタブバー要素設置
            self.viewControllers?[index].tabBarItem.tag = index
            self.viewControllers?[index].tabBarItem.setTitleTextAttributes(normalAttributes, for: [])
            self.viewControllers?[index].tabBarItem.setTitleTextAttributes(selectedAttributes, for: .selected)
            self.viewControllers?[index].tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: -1.0)
            self.viewControllers?[index].tabBarItem.image = UIImage.fontAwesomeIcon(name: tabBarItem.getTabFontAwesomeIcon(), style: .solid, textColor: normalColor, size: itemSize).withRenderingMode(.alwaysOriginal)
            self.viewControllers?[index].tabBarItem.selectedImage = UIImage.fontAwesomeIcon(name: tabBarItem.getTabFontAwesomeIcon(), style: .solid, textColor: selectedColor, size: itemSize).withRenderingMode(.alwaysOriginal)
        }
    }
}

extension GlobaTabBarController: UITabBarControllerDelegate {}
