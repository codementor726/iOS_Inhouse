//
//  AvailableReservationModel.swift
//  InHouse
//
//  Created by Kevin Johnson on 9/14/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import Foundation

struct AvailableReservationModel {
    var restaurant: String
    var neighborhood: String?
    var address: String
    var timeslots: [Timeslot]?
    
    init(restaurant: String, neighborhood: String?, address: String, timeslots: [Timeslot]?) {
        self.restaurant = restaurant
        self.neighborhood = neighborhood
        self.address = address
        self.timeslots = timeslots
    }
}
