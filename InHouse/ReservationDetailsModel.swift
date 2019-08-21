//
//  ReservationDetailsModel.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/30/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import Foundation

struct ReservationDetailsModel {
    let restaurant: Restaurant
    var partySize: Int
    var date: Date
    var time: String?
    
    init(restaurant: Restaurant, partySize: Int, date: Date, time: String?) {
        self.restaurant = restaurant
        self.partySize = partySize
        self.date = date
        self.time = time
    }
}
