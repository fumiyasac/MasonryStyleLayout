//
//  PhotoGalleryDetailPickButtonView.swift
//  MasonryStyleLayout
//
//  Created by 酒井文也 on 2019/01/23.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift

class PhotoGalleryDetailPickButtonView: CustomViewBase {

    var pickPhotoButtonAction: (() -> ())?

    private let iconSize: CGSize = CGSize(width: 36.0, height: 36.0)

    @IBOutlet weak private var iconImageView: UIImageView!
    @IBOutlet weak private var pickPhotoButton: UIButton!

    // MARK: - Initializer
    
    required init(frame: CGRect) {
        super.init(frame: frame)

        setupPickButton()
        setupIconImageView()
        setupPhotoGalleryDetailPickButtonView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupPickButton()
        setupIconImageView()
        setupPhotoGalleryDetailPickButtonView()
    }

    // MARK: - Function

    func changeState(isPicked: Bool = false) {
        let iconColor: UIColor = isPicked ? .red : .white
        iconImageView.image = UIImage.fontAwesomeIcon(name: .heart, style: .solid, textColor: iconColor, size: iconSize)
    }

    // MARK: - Private Function

    @objc private func executePickButtonAction() {
        pickPhotoButtonAction?()
    }

    // Pickボタン部分の初期設定を行う
    private func setupPickButton() {
        pickPhotoButton.addTarget(self, action: #selector(self.executePickButtonAction), for: .touchUpInside)
    }

    // 画像アイコン部分の初期設定を行う
    private func setupIconImageView() {
        let iconColor: UIColor = .white
        iconImageView.image = UIImage.fontAwesomeIcon(name: .heart, style: .solid, textColor: iconColor, size: iconSize)
    }

    // ボタンのViewに関する初期設定を行う
    private func setupPhotoGalleryDetailPickButtonView() {
        self.layer.cornerRadius = self.frame.width / 2
    }
}
