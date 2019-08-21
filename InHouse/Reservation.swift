//
//  Reservation.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/13/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import ObjectMapper

enum ReservationStatus: String {
    case pending = "pending"
    case booked = "booked"
    case past = "past"
}

class Reservation: Mappable {
    var id: Int!
    var restaurantName: String!
    var userId: Int!
    var date: String!
    var time: String? // All reservations after new release around ~9/22 will have
    var prefTime: Date?
    var minTime: Date?
    var maxTime: Date?
    var partySize: Int!
    var status: ReservationStatus {
        get { return ReservationStatus.init(rawValue: privateStatus)! }
        set { privateStatus = newValue.rawValue }
    }
    private var privateStatus: String!
    var type: String!
    var comments: String?
    var createdAt: Date!
    var updatedAt: Date!
    var tableType: String?
    var restaurant: Restaurant!
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        id <- map["id"]
        userId <- map["user_id"]
        date <- map["date"]
        time <- map["time"]
        restaurantName <- map["restaurant_name"]
        prefTime <- (map["preferred_time"], InHouseDateTransform())
        minTime <- (map["min_time"], InHouseDateTransform())
        maxTime <- (map["max_time"], InHouseDateTransform())
        partySize <- map["party_size"]
        privateStatus <- map["status"]
        type <- map["type"]
        comments <- map["comments"]
        tableType <- map["table_type"]
        createdAt <- (map["created_at"], InHouseDateTransform())
        updatedAt <- (map["updated_at"], InHouseDateTransform())
        restaurant = Restaurant(map: map)
        restaurant.mapping(map: map)
    }
}

// MARK: - Helper

extension Reservation {
    func simpleDescription()-> String {
        switch status {
        case .pending:
            return "\(time ?? "") @ \(restaurantName ?? "") (Pending)"
        case .booked, .past:
            return "\(time ?? "") @ \(restaurantName ?? "")"
        }
    }
}
