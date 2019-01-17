//
//  PhotoGalleryCollectionHeaderView.swift
//  MasonryStyleLayout
//
//  Created by 酒井文也 on 2019/01/16.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import UIKit

class PhotoGalleryCollectionHeaderView: UICollectionReusableView {

    static let viewSize: CGSize = CGSize(width: UIScreen.main.bounds.width, height: 56.0)

    @IBOutlet weak private var sectionTitleLabel: UILabel!

    // MARK: - Function

    func setSectionTitle(_ title: String) {
        sectionTitleLabel.text = title
    }
}
