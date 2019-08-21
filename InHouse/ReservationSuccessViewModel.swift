//
//  ReservationSuccessViewModel.swift
//  InHouse
//
//  Created by Kevin Johnson on 9/19/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import Foundation

struct ReservationSuccessViewModel{
    var reservationType: ReservationType
    var restaurant: String
    var partySize: Int
    var date: String
    var time: String
    
    init(_ type: ReservationType, restaurant: String, partySize: Int, date: String, time: String) {
        self.reservationType = type
        self.restaurant = restaurant
        self.partySize = partySize
        self.date = date
        self.time = time
    }
    
    enum ReservationType {
        case request, booking
    }
}
