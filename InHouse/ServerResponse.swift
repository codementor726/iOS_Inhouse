//
//  ServerResponse.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/20/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import ObjectMapper

private let unauthenticatedMessage = "Unauthenticated."

class ServerResponse: Mappable {
    
    // MARK: Variables
    
    var success: Bool!
    var reservation: Reservation?
    var reservations: [Reservation]?
    var restaurant: Restaurant?
    var restaurants: [Restaurant]?
    var newsFeedItem: NewsFeedItem?
    var newsFeedItems: [NewsFeedItem]?
    var availableInventoryItem: AvailableInventoryItem?
    var availableInventoryItems: [AvailableInventoryItem]?
    var user: User?
    var users: [User]?
    var neighborhood: Neighborhood?
    var neighborhoods: [Neighborhood]?
    var pageInfo: PageInfo?
    var message: String? {
        didSet {
            authenticatedCheck()
        }
    }
    
    // MARK: Mapping
    
    func mapping(map: Map) {
        success <- map["success"]
        reservation <- map["data"]
        reservations <- map["data"]
        restaurant <- map["data"]
        restaurants <- map["data"]
        newsFeedItem <- map["data"]
        newsFeedItems <- map["data"]
        availableInventoryItem <- map["data"]
        availableInventoryItems <- map["data"]
        user <- map["data"]
        users <- map["data"]
        neighborhood <- map["data"]
        neighborhoods <- map["data"]
        pageInfo <- map["message"]
        message <- map["message"]
    }
    
    // MARK: Init
    
    required init?(map: Map) { }
    
}

// MARK: Helper Functions

extension ServerResponse {
    func authenticatedCheck() {
        if message == unauthenticatedMessage {
            DispatchQueue.main.sync {
                (UIApplication.shared.delegate as? AppDelegate)?.unauthLogout()
            }
        }
    }
}
