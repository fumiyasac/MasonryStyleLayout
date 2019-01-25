//
//  SettingViewController.swift
//  MasonryStyleLayout
//
//  Created by 酒井文也 on 2019/01/25.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import UIKit
import SwiftyMarkdown

class SettingViewController: UIViewController {

    @IBOutlet weak private var markdownTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupMarkdownDocument()
    }    

    // MARK: - Private Function

    // ナビゲーションバーに関する初期設定をする
    private func setupNavigationBar() {
        setupNavigationBarTitle("サンプルの説明書")
        removeBackButtonText()
    }

    // Markdownドキュメントに関する初期設定をする
    private func setupMarkdownDocument() {
        markdownTextView.dataDetectorTypes = .all
        if let url = Bundle.main.url(forResource: "setting", withExtension: "md"), let md = SwiftyMarkdown(url: url) {
            md.setFontNameForAllStyles(with: "HiraKakuProN-W3")
            md.setFontSizeForAllStyles(with: 11.0)
            md.h1.fontName = "HiraKakuProN-W6"
            md.h1.fontSize = 16.0
            md.h2.fontName = "HiraKakuProN-W6"
            md.h2.fontSize = 14.0
            md.h3.fontName = "HiraKakuProN-W6"
            md.h3.fontSize = 12.0
            markdownTextView.attributedText = md.attributedString()
        }
    }
}
