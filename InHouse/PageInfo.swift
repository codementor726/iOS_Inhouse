//
//  PageInfo.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/11/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import ObjectMapper

class PageInfo: Mappable {
    var status: String!
    var showFeatured: Bool = false // Only on news feed
    var pages: Int!
    var page: Int!
    var total: Int!
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        status <- map["status"]
        pages <- map["pages"]
        page <- map["page"]
        total <- map["total"]
        showFeatured <- map["show_featured"]
    }
    
    func hasNextPage() -> Bool {
        return page < pages
    }
}
