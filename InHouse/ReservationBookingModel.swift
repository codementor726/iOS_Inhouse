//
//  ReservationBookingModel.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/29/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import Foundation

struct ReservationBookingModel {
    var restaurant: Restaurant!
    var date: Date
    var timeslot: Timeslot
    var partySize: Int
    
    init(_ restaurant: Restaurant, date: Date = Date.tomorrow(), timeslot: Timeslot, partySize: Int = 2) {
        self.restaurant = restaurant
        self.date = date
        self.timeslot = timeslot
        self.partySize = partySize
    }
}
