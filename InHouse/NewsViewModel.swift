//
//  NewsViewModel.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/31/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import Foundation

struct NewsViewModel {
    var id: Int?
    var title: String?
    var description: String?
    var date: Date?
    var imagePath: String?
    var urlString: String?
    var likes: Int?
    var isLiked: Bool?
    
    init(id: Int?, title: String?, description: String?, date: Date?, imagePath: String?, urlString: String?, likes: Int?, isLiked: Bool?) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
        self.imagePath = imagePath
        self.urlString = urlString
        self.likes = likes
        self.isLiked = isLiked
    }
    
    init(_ item: NewsFeedItem) {
        self.id = item.id
        self.title = item.title
        self.description = item.description
        self.date = item.createdAt
        self.imagePath = item.imagePath
        self.urlString = item.urlString
        self.likes = item.likes
        self.isLiked = item.isLiked
    }
}

struct FeaturedNewsModel {
    var imagePath: String?
    var headline: String?
    
    init(item: NewsFeedItem) {
        self.headline = item.title
        self.imagePath = item.imagePath
    }
}
