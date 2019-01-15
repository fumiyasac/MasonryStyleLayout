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

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUserInterface()
    }

    // MARK: - Function

    func setCellDisplayData(_ photo: PhotoEntity) {
        
        // 画像データを表示する
        if let photoImageURL = photo.imageUrl {
            thumbnailImageView.af_setImage(withURL: photoImageURL)
        }

        // タイトル表示用ラベルの装飾を適用して表示する
        let titleAttributes = getAttributesForLabel(
            lineSpacing: 5,
            font: UIFont(name: "HiraKakuProN-W6", size: 12.0)!,
            foregroundColor: UIColor(code: "#333333")
        )
        titleLabel.attributedText = NSAttributedString(string: photo.title, attributes: titleAttributes)

        // サマリー表示用ラベルの装飾を適用して表示する
        let summaryAttributes = getAttributesForLabel(
            lineSpacing: 6,
            font: UIFont(name: "HiraKakuProN-W3", size: 11.0)!,
            foregroundColor: UIColor(code: "#777777")
        )
        summaryLabel.attributedText = NSAttributedString(string: photo.summary, attributes: summaryAttributes)

        // 著者表示用ラベルを表示する
        summaryLabel.attributedText = NSAttributedString(string: photo.summary, attributes: summaryAttributes)

        // セルの装飾を適用する
        setCellDecoration()
    }

    // MARK: - Private Function

    // ラベルの装飾用(行間やフォント・配色)attributesを取得する
    private func getAttributesForLabel(lineSpacing: CGFloat, font: UIFont, foregroundColor: UIColor) -> [NSAttributedString.Key : Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing

        // MEMO: これを指定しないとはみ出た場合の「...」が出なくなる
        paragraphStyle.lineBreakMode = .byTruncatingTail

        var attributes: [NSAttributedString.Key : Any] = [:]
        attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        attributes[NSAttributedString.Key.font] = font
        attributes[NSAttributedString.Key.foregroundColor] = foregroundColor
        return attributes
    }

    // セルの装飾(罫線やシャドウ等のlayerプロパティに対して適用するもの)を適用する
    private func setCellDecoration() {

        // UICollectionViewのcontentViewプロパティには罫線と角丸に関する設定を行う
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 8.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor(code: "#dddddd").cgColor

        // UICollectionViewのおおもとの部分にはドロップシャドウに関する設定を行う
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor(code: "#aaaaaa").cgColor
        self.layer.shadowOffset = CGSize(width: 0.75, height: 1.75)
        self.layer.shadowRadius = 2.5
        self.layer.shadowOpacity = 0.33

        // サムネイル用プロパティには罫線と角丸に関する設定を行う
        self.thumbnailImageView.layer.masksToBounds = true
        self.thumbnailImageView.layer.cornerRadius = 8.0
        self.thumbnailImageView.layer.borderWidth = 1.0
        self.thumbnailImageView.layer.borderColor = UIColor(code: "#dddddd").cgColor

        // ドロップシャドウの形状をcontentViewに付与した角丸を考慮するようにする
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }

    private func setupUserInterface() {
        setupIconImageView()
    }

    private func setupIconImageView() {
        iconImageView.image = UIImage.fontAwesomeIcon(name: .image, style: .solid, textColor: UIColor.darkGray, size: CGSize(width: 16.0, height: 16.0))
    }
}
