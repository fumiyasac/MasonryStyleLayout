//
//  DesignFormatter.swift
//  MasonryStyleLayout
//
//  Created by 酒井文也 on 2019/01/24.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation
import UIKit

final class DesignFormatter {
    
    // MARK: - Static Function

    // 該当のUILabelに付与する属性を設定する
    static func getLabelAttributesBy(keys: (lineSpacing: CGFloat, font: UIFont, foregroundColor: UIColor)) -> [NSAttributedString.Key : Any] {

        // 行間に関する設定をする
        // MEMO: lineBreakModeの指定しないとはみ出た場合の「...」が出なくなる
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = keys.lineSpacing
        paragraphStyle.lineBreakMode = .byTruncatingTail

        // 上記で定義した行間・フォント・色を属性値として設定する
        var attributes: [NSAttributedString.Key : Any] = [:]
        attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        attributes[NSAttributedString.Key.font] = keys.font
        attributes[NSAttributedString.Key.foregroundColor] = keys.foregroundColor

        return attributes
    }

    // 該当のUICollectionViewCellとその内部要素へ装飾wをする
    static func decorateCollectionViewCell(_ cell: UICollectionViewCell, withinImageView imageView: UIImageView? = nil) {

        let borderColor: CGColor = UIColor(code: "#dddddd").cgColor
        let shadowColor: CGColor = UIColor(code: "#aaaaaa").cgColor
        let shadowSize: CGSize = CGSize(width: 0.75, height: 1.75)

        // UICollectionViewのcontentViewプロパティには罫線と角丸に関する設定を行う
        cell.contentView.layer.masksToBounds = true
        cell.contentView.layer.cornerRadius = 8.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = borderColor
        
        // UICollectionViewのおおもとの部分にはドロップシャドウに関する設定を行う
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = shadowColor
        cell.layer.shadowOffset = shadowSize
        cell.layer.shadowRadius = 2.5
        cell.layer.shadowOpacity = 0.33
        
        // サムネイル用プロパティには罫線と角丸に関する設定を行う
        if let imageView = imageView {
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = 8.0
            imageView.layer.borderWidth = 1.0
            imageView.layer.borderColor = borderColor
        }

        // ドロップシャドウの形状をcontentViewに付与した角丸を考慮するようにする
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
    }
}
