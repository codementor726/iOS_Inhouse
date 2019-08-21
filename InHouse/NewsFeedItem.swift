//
//  NewsFeedItem.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/17/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import ObjectMapper

// Content in CMS has been entered with missing info, use optional properties
class NewsFeedItem: Mappable {
    var id: Int?
    var title: String?
    var imagePath: String?
    var description: String?
    var urlString: String?
    var type: String?
    var likes: Int?
    var isLiked: Bool?
    var published: Bool?
    var createdAt: Date?
    var updatedAt: Date?
    var isFeatured: Bool = false
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        description <- map["description"]
        imagePath <- map["image"]
        urlString <- map["url"]
        type <- map["type"]
        likes <- map["likes"]
        isFeatured <- map["is_featured"]
        isLiked <- map["is_liked"]
        published <- map["published"]
        createdAt <- (map["created_at"], InHouseDateTransform())
        updatedAt <- (map["updated_at"], InHouseDateTransform())
    }
}
