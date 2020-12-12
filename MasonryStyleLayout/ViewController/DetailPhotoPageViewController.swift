//
//  DetailPhotoPageViewController.swift
//  MasonryStyleLayout
//
//  Created by 酒井文也 on 2019/01/23.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import UIKit
import AlamofireImage

final class DetailPhotoPageViewController: UIViewController {

    @IBOutlet weak private var photoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Function

    func setPhoto(_ url: URL?) {
        if let imageUrl = url {
            // MEMO: サーバーサイドで画像リサイズ処理を施したサムネイルを表示する
            photoImageView.af.setImage(withURL: imageUrl)
        }
    }
}
