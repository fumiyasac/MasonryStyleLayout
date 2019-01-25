//
//  TabBarItemsType.swift
//  MasonryStyleLayout
//
//  Created by 酒井文也 on 2019/01/25.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift

// GloalTabBarControllerへ配置するものに関する設定
enum TabBarItemsType: CaseIterable {

    case main
    case setting
    
    // MARK: - Function
    
    // 該当のViewControllerを取得する
    func getViewController() -> UIViewController? {
        var storyboardName: String
        switch self {
        case .main:
            storyboardName = "Main"
        case .setting:
            storyboardName = "Setting"
        }
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateInitialViewController()
    }
    
    // GlobalTabBarのインデックス番号を取得する
    func getTabIndex() -> Int {
        switch self {
        case .main:
            return 0
        case .setting:
            return 1
        }
    }
    
    // GlobalTabBarのタイトルを取得する
    func getTabTitle() -> String {
        switch self {
        case .main:
            return "写真コンテンツ"
        case .setting:
            return "サンプルの説明"
        }
    }
    
    // tabBarのFontAwesomeアイコン名を取得する
    func getTabFontAwesomeIcon() -> FontAwesome {
        switch self {
        case .main:
            return .images
        case .setting:
            return .cog
        }
    }
}
