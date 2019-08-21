//
//  ReservationRequestModel.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/29/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import Foundation

struct ReservationRequestModel {
    var restaurant: Restaurant
    var date: Date
    var partySize: Int
    var prefTime: Date?
    var maxTime: Date?
    var minTime: Date?
    
    init(_ restaurant: Restaurant, date: Date = Date.tomorrow(), partySize: Int = 2) {
        self.restaurant = restaurant
        self.date = date
        self.partySize = partySize
    }
}
