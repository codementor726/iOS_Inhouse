//
//  Tokens.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/11/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import ObjectMapper

class Tokens: Mappable {
    
    var access: String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        access <- map["access_token"]
    }
}

