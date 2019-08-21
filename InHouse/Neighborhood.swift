//
//  Neighborhood.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/25/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import ObjectMapper

class Neighborhood: Mappable {
    
    var id: Int!
    var name: String!
    var cityId: Int!
    var state: String!
    var createdAt: Date!
    var updatedAt: Date!
    var restaurantCount: Int!
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        cityId <- map["city_id"]
        state <- map["state"]
        createdAt <- (map["created_at"], InHouseDateTransform())
        updatedAt <- (map["updated_at"], InHouseDateTransform())
        restaurantCount <- map["restaurant_count"]
    }
}

// MARK: Helper Func

extension Neighborhood {
    func displayString()-> String {
        return "\(name!) (\(restaurantCount!))"
    }
}

// MARK: Equatable

extension Neighborhood: Equatable {
    public static func ==(lhs: Neighborhood, rhs: Neighborhood) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}
