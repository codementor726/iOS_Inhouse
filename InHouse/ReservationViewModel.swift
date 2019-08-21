//
//  ReservationViewModel.swift
//  InHouse
//
//  Created by Kevin Johnson on 9/19/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import Foundation

struct ReservationViewModel {
    var date: Date
    var restaurant: String
    var address: String
    var partySize: Int
    var time: String?
    var status: ReservationStatus
    
    init(_ reservation: Reservation, status: ReservationStatus) {
        self.date = reservation.date.convertApiDateStringToDate()!
        self.restaurant = reservation.restaurantName
        self.address = reservation.restaurant.crossStreets
        self.partySize = reservation.partySize
        self.time = reservation.time ?? reservation.prefTime?.timeString()
        self.status = status
    }
}
