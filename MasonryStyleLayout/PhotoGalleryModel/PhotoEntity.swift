//
//  PhotoGalleryListEntity.swift
//  MasonryStyleLayout
//
//  Created by 酒井文也 on 2019/01/11.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PhotoEntity {

    private (set)var id: Int = 0
    private (set)var categoryNumber: Int = 0
    private (set)var author: String = ""
    private (set)var title: String = ""
    private (set)var summary: String = ""
    private (set)var imageUrl: URL? = nil
    private (set)var rating: String = ""

    // MARK: - Initializer

    init(_ json: JSON) {
        if let id = json["id"].int {
            self.id = id
        }
        if let categoryNumber = json["category_number"].int {
            self.categoryNumber = categoryNumber
        }
        if let author = json["author"].string {
            self.author = author
        }
        if let title = json["title"].string {
            self.title = title
        }
        if let summary = json["summary"].string {
            self.summary = summary
        }
        if let imageUrl = json["image_url"].string {
            self.imageUrl = URL(string: imageUrl)
        }
        if let rating = json["rating"].string {
            self.rating = rating
        }
    }
}
