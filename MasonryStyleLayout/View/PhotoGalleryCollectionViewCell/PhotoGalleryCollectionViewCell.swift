//
//  PhotoGalleryCollectionViewCell.swift
//  MasonryStyleLayout
//
//  Created by 酒井文也 on 2019/01/07.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import UIKit
import FontAwesome_swift
import AlamofireImage

class PhotoGalleryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var thumbnailImageView: UIImageView!
    @IBOutlet weak private var summaryLabel: UILabel!
    @IBOutlet weak private var authorLabel: UILabel!
    @IBOutlet weak private var iconImageView: UIImageView!

    // 高さが可変となるUILabelの高さ制約値
    @IBOutlet weak private var titleHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupIconImageView()
    }

    // MARK: - Function

    func setCellDisplayData(_ photo: PhotoEntity) {

        // 画像データを表示する
        if let photoImageURL = photo.imageUrl {
            thumbnailImageView.af.setImage(withURL: photoImageURL)
        }

        // タイトル表示用ラベルの装飾を適用して表示する
        let titleKeys = (
            lineSpacing: CGFloat(5),
            font: UIFont(name: "HiraKakuProN-W6", size: 12.0)!,
            foregroundColor: UIColor(code: "#333333")
        )
        let titleAttributes = DesignFormatter.getLabelAttributesBy(keys: titleKeys)
        titleLabel.attributedText = NSAttributedString(string: photo.title, attributes: titleAttributes)

        // 属性テキストに合わせた高さをラベル制約へ適用する
        titleHeightConstraint.constant = titleLabel.sizeThatFits(titleLabel.frame.size).height

        // サマリー表示用ラベルの装飾を適用して表示する
        let summaryKeys = (
            lineSpacing: CGFloat(6),
            font: UIFont(name: "HiraKakuProN-W3", size: 11.0)!,
            foregroundColor: UIColor(code: "#777777")
        )
        let summaryAttributes = DesignFormatter.getLabelAttributesBy(keys: summaryKeys)
        summaryLabel.attributedText = NSAttributedString(string: photo.summary, attributes: summaryAttributes)

        // 著者表示用ラベルを表示する
        authorLabel.text = photo.author

        // セルの装飾を適用する
        DesignFormatter.decorateCollectionViewCell(self, withinImageView: thumbnailImageView)
    }

    // MARK: - Private Function

    // 画像アイコン部分の初期設定を行う
    private func setupIconImageView() {
        let iconColor: UIColor = .darkGray
        let iconSize: CGSize = CGSize(width: 16.0, height: 16.0)
        iconImageView.image = UIImage.fontAwesomeIcon(name: .image, style: .solid, textColor: iconColor, size: iconSize)
    }
}
