//
//  PhotoGalleryHandleButtonView.swift
//  MasonryStyleLayout
//
//  Created by 酒井文也 on 2019/01/17.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift

class PhotoGalleryHandleButtonView: CustomViewBase {

    var requestApiButtonAction: (() -> ())?

    // APIリクエスト用のボタン表示で必要なUI部品
    @IBOutlet weak private var requestApiButtonView: UIView!
    @IBOutlet weak private var requestApiButton: UIButton!
    @IBOutlet weak private var arrowImageView: UIImageView!

    // ローディング中の表示で必要なUI部品
    @IBOutlet weak private var loadingIndicatiorView: UIView!
    @IBOutlet weak private var loadingIndicator: UIActivityIndicatorView!

    // MARK: - Initializer

    required init(frame: CGRect) {
        super.init(frame: frame)

        setupCalendarButtonView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupCalendarButtonView()
    }

    // MARK: - Function

    func changeState(isFetchingData: Bool = false) {
        requestApiButtonView.isHidden  = isFetchingData
        loadingIndicatiorView.isHidden = !isFetchingData
    }

    // MARK: - Private Function

    @objc private func executeRequestApiButtonAction() {
        requestApiButtonAction?()
    }

    private func setupCalendarButtonView() {
        
        // 下向きの矢印表示で必要な初期設定
        let iconColor = UIColor(code: "#00a6ff")
        let iconSize  = CGSize(width: 16.0, height: 16.0)
        arrowImageView.image = UIImage.fontAwesomeIcon(name: .arrowDown, style: .solid, textColor: iconColor, size: iconSize)

        // インジケーター表示で必要な初期設定
        loadingIndicator.startAnimating()

        // APIリクエスト用のボタンで必要な初期設定
        requestApiButton.addTarget(self, action: #selector(self.executeRequestApiButtonAction), for: .touchUpInside)
    }
}
