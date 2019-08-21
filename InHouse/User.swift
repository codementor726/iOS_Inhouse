//
//  User.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/17/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import ObjectMapper

class User: Mappable {
    
    var id: Int!
    var type: String!
    var firstName: String!
    var lastName: String?
    var email: String!
    var phone: String!
    var birthday: String?
    var anniversary: String?
    var partnerName: String?
    var maritalStatus: String?
    var favoriteDrinks: String?
    var allergies: String?
    var approved: Bool!
    var createdAt: Date!
    var updatedAt: Date!
    var tokens: Tokens?
    var restauranName: String?
    var restaurantPosition: String?
    var formerPositions: String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        id <- map["id"]
        type <- map["type"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        email <- map["email"]
        phone <- map["phone"]
        birthday <- map["birthday"] 
        anniversary <- map["anniversary"]
        partnerName <- map["partner_name"]
        favoriteDrinks <- map[Keys.User.Drinks]
        formerPositions <- map[Keys.User.FormerPositions]
        maritalStatus <- map["marital_status"]
        allergies <- map["allergies"]
        approved <- map["approved"]
        restauranName <- map["restaurant_name"]
        restaurantPosition <- map["position_at_restaurant"]
        createdAt <- (map["created_at"], InHouseDateTransform())
        updatedAt <- (map["updated_at"], InHouseDateTransform())
        tokens <- map["tokens"]
    }
}
