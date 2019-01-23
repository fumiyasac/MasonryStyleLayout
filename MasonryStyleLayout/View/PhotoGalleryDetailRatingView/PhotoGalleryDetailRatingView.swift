//
//  PhotoGalleryDetailRatingView.swift
//  MasonryStyleLayout
//
//  Created by 酒井文也 on 2019/01/23.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift

class PhotoGalleryDetailRatingView: CustomViewBase {
    
    @IBOutlet weak private var iconImageView: UIImageView!
    @IBOutlet weak private var ratingLabel: UILabel!

    // MARK: - Initializer
    
    required init(frame: CGRect) {
        super.init(frame: frame)

        setupIconImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupIconImageView()
    }

    // MARK: - Function
    
    func setRating(_ photo: PhotoEntity) {
        ratingLabel.text = photo.rating
    }

    // MARK: - Private Function

    // 画像アイコン部分の初期設定を行う
    private func setupIconImageView() {
        let iconColor: UIColor = .white
        let iconSize: CGSize = CGSize(width: 20.0, height: 20.0)
        iconImageView.image = UIImage.fontAwesomeIcon(name: .star, style: .solid, textColor: iconColor, size: iconSize)
    }
}
