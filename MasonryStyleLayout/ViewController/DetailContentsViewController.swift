//
//  DetailContentsViewController.swift
//  MasonryStyleLayout
//
//  Created by 酒井文也 on 2019/01/22.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import UIKit

final class DetailContentsViewController: UIViewController {

    @IBOutlet weak private var detailPhotoCountainer: UIView!
    @IBOutlet weak private var detailPhotoPageControl: UIPageControl!

    @IBOutlet weak private var detailPickButtonView: PhotoGalleryDetailPickButtonView!
    @IBOutlet weak private var detailRatingView: PhotoGalleryDetailRatingView!
    @IBOutlet weak private var detailInformationView: PhotoGalleryDetailInformationView!

    @IBOutlet weak private var relatedCollectionView: UICollectionView!
    @IBOutlet weak private var relatedErrorView: PhotoGalleryRelatedErrorView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
