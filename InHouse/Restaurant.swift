//
//  Restaurant.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/17/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import ObjectMapper
import CoreLocation

class Restaurant: Mappable {
    var id: Int!
    var name: String!
    var description: String!
    var address: String!
    var secondary: String!
    var crossStreets: String!
    var city: String!
    var state: String!
    var zipCode: Int!
    var phone: String!
    var website: String?
    var neighborhoodId: Int!
    var neighborhood: String!
    var tagOne: String!
    var opens: String!
    var closes: String!
    var createdAt: Date!
    var updatedAt: Date!
    var wine: String?
    var menus: String?
    var lat: Double?
    var long: Double?
    var center: CLLocationCoordinate2D? {
        guard let lat = lat, let long = long else { return nil }
        return CLLocationCoordinate2D.init(latitude: lat, longitude: long)
    }
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        id <- map["restaurant_id"]
        id <- map["id"]
        name <- map["restaurant_name"]
        name <- map["name"]
        description <- map["description"]
        address <- map["street_address"]
        secondary <- map["secondary_address"]
        city <- map["city_name"]
        state <- map["state"]
        website <- map["website"]
        crossStreets <- map["cross_streets"]
        wine <- map["wine"]
        menus <- map["menus"]
        tagOne <- map["tag1_name"]
        zipCode <- map["zip_code"]
        lat <- map["lat"]
        long <- map["lng"]
        phone <- map["phone"]
        website <- map["website"]
        neighborhoodId <- map["neighborhood_id"]
        neighborhood <- map["neighborhood_name"]
        opens <- map["opens_at"]
        closes <- map["closes_at"]
        createdAt <- (map["created_at"], InHouseDateTransform())
        updatedAt <- (map["updated_at"], InHouseDateTransform())
    }
}
