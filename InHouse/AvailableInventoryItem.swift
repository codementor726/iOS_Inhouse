//
//  AvailableInventoryItem.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/17/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import ObjectMapper

class AvailableInventoryItem: Mappable {
    
    var id: Int!
    var timeslots: [Timeslot]?
    var restaurant: Restaurant!
    var createdAt: Date!
    var updatedAt: Date!

    required init?(map: Map){ }
    
    func mapping(map: Map) {
        timeslots <- map["timeslots"]
        id <- map["id"]
        createdAt <- (map["created_at"], InHouseDateTransform())
        updatedAt <- (map["updated_at"], InHouseDateTransform())
        restaurant = Restaurant(map: map)
        restaurant.mapping(map: map)
    }
}
