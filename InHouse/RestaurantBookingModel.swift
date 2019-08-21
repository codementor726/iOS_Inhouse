//
//  RestaurantBookingModel.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/30/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import Foundation

struct RestaurantBookingModel {
    let restaurant: Restaurant
    var partySize: Int
    var date: Date
    var timeslots: [Timeslot]?
    
    init(restaurant: Restaurant, partySize: Int, date: Date, timeslots: [Timeslot]?) {
        self.restaurant = restaurant
        self.partySize = partySize
        self.date = date
        self.timeslots = timeslots
    }
}
