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
            thumbnailImageView.af_setImage(withURL: photoImageURL)
        }

        // タイトル表示用ラベルの装飾を適用して表示する
        let titleFont = UIFont(name: "HiraKakuProN-W6", size: 12.0)!
        let titleColor = UIColor(code: "#333333")
        let titleAttributes = getAttributesForLabel(lineSpacing: 5, font: titleFont, foregroundColor: titleColor)
        titleLabel.attributedText = NSAttributedString(string: photo.title, attributes: titleAttributes)

        // 属性テキストに合わせた高さをラベル制約へ適用する
        titleHeightConstraint.constant = titleLabel.sizeThatFits(titleLabel.frame.size).height

        // サマリー表示用ラベルの装飾を適用して表示する
        let summaryFont = UIFont(name: "HiraKakuProN-W3", size: 11.0)!
        let summaryColor = UIColor(code: "#777777")
        let summaryAttributes = getAttributesForLabel(lineSpacing: 6, font: summaryFont, foregroundColor: summaryColor)
        summaryLabel.attributedText = NSAttributedString(string: photo.summary, attributes: summaryAttributes)

        // 著者表示用ラベルを表示する
        authorLabel.text = photo.author

        // セルの装飾を適用する
        setCellDecoration()
    }

    // MARK: - Private Function

    // ラベルの装飾用(行間やフォント・配色)attributesを取得する
    private func getAttributesForLabel(lineSpacing: CGFloat, font: UIFont, foregroundColor: UIColor) -> [NSAttributedString.Key : Any] {

        // 行間に関する設定をする
        // MEMO: lineBreakModeの指定しないとはみ出た場合の「...」が出なくなる
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineBreakMode = .byTruncatingTail

        var attributes: [NSAttributedString.Key : Any] = [:]
        attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        attributes[NSAttributedString.Key.font] = font
        attributes[NSAttributedString.Key.foregroundColor] = foregroundColor
        return attributes
    }

    // セルの装飾(罫線やシャドウ等のlayerプロパティに対して適用するもの)を適用する
    private func setCellDecoration() {

        let borderColor: CGColor = UIColor(code: "#dddddd").cgColor
        let shadowColor: CGColor = UIColor(code: "#aaaaaa").cgColor
        let shadowSize: CGSize = CGSize(width: 0.75, height: 1.75)

        // UICollectionViewのcontentViewプロパティには罫線と角丸に関する設定を行う
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 8.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = borderColor

        // UICollectionViewのおおもとの部分にはドロップシャドウに関する設定を行う
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor
        self.layer.shadowOffset = shadowSize
        self.layer.shadowRadius = 2.5
        self.layer.shadowOpacity = 0.33

        // サムネイル用プロパティには罫線と角丸に関する設定を行う
        self.thumbnailImageView.layer.masksToBounds = true
        self.thumbnailImageView.layer.cornerRadius = 8.0
        self.thumbnailImageView.layer.borderWidth = 1.0
        self.thumbnailImageView.layer.borderColor = borderColor

        // ドロップシャドウの形状をcontentViewに付与した角丸を考慮するようにする
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }

    // 画像アイコン部分の初期設定を行う
    private func setupIconImageView() {
        let iconColor: UIColor = .darkGray
        let iconSize: CGSize = CGSize(width: 16.0, height: 16.0)
        iconImageView.image = UIImage.fontAwesomeIcon(name: .image, style: .solid, textColor: iconColor, size: iconSize)
    }
}
