//
//  PhotoGalleryRelatedErrorView.swift
//  MasonryStyleLayout
//
//  Created by 酒井文也 on 2019/01/23.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation
import UIKit

class PhotoGalleryRelatedErrorView: CustomViewBase {

    var retryRecommendButtonAction: (() -> ())?

    @IBOutlet weak private var retryRecommendButton: UIButton!

    // MARK: - Initializer

    required init(frame: CGRect) {
        super.init(frame: frame)

        setupRetryRecommendButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupRetryRecommendButton()
    }

    // MARK: - Private Function

    @objc private func executeRetryRecommendButtonAction() {
        retryRecommendButtonAction?()
    }

    // Pickボタン部分の初期設定を行う
    private func setupRetryRecommendButton() {
        retryRecommendButton.superview?.layer.borderWidth = 0.5
        retryRecommendButton.superview?.layer.borderColor = UIColor(code: "#00A6FF").cgColor
        retryRecommendButton.superview?.layer.cornerRadius = retryRecommendButton.frame.height / 2
        retryRecommendButton.addTarget(self, action: #selector(self.executeRetryRecommendButtonAction), for: .touchUpInside)
    }
}
