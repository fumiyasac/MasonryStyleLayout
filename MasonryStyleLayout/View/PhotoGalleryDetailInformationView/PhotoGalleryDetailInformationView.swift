//
//  PhotoGalleryDetailInformationView.swift
//  MasonryStyleLayout
//
//  Created by 酒井文也 on 2019/01/23.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation
import UIKit

class PhotoGalleryDetailInformationView: CustomViewBase {

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var summaryLabel: UILabel!
    @IBOutlet weak private var authorLabel: UILabel!

    // MARK: - Function

    func setText(_ photo: PhotoEntity) {

        // タイトル表示用ラベルの装飾を適用して表示する
        let titleKeys = (
            lineSpacing: CGFloat(5),
            font: UIFont(name: "HiraKakuProN-W6", size: 12.0)!,
            foregroundColor: UIColor(code: "#333333")
        )
        let titleAttributes = DesignFormatter.getLabelAttributesBy(keys: titleKeys)
        titleLabel.attributedText = NSAttributedString(string: photo.title, attributes: titleAttributes)

        // サマリー表示用ラベルの装飾を適用して表示する
        let summaryKeys = (
            lineSpacing: CGFloat(6),
            font: UIFont(name: "HiraKakuProN-W3", size: 11.0)!,
            foregroundColor: UIColor(code: "#777777")
        )
        let summaryAttributes = DesignFormatter.getLabelAttributesBy(keys: summaryKeys)
        summaryLabel.attributedText = NSAttributedString(string: photo.summary, attributes: summaryAttributes)

        // 著者表示用ラベルの装飾を適用して表示する
        authorLabel.text = photo.author
    }
}
