//
//  CategoryNumberType.swift
//  MasonryStyleLayout
//
//  Created by 酒井文也 on 2019/01/18.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation
import UIKit

enum CategoryNumberType: Int {

    case first  = 1
    case second = 2
    case third  = 3
    case fourth = 4
    case fifth  = 5
    case sixth  = 6

    // MARK: - Function

    func getCategoryTitle() -> String {
        return "\(self.rawValue)番目のカテゴリーで表示する写真一覧"
    }
}
