//
//  DateExtensions.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/30/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import Foundation

extension Date {
    func stringWithFormat(_ format: String)-> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func apiString()-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    func timeString()-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
    // Don't set timezone here, this assures that the printed time that is passed is in whatever string they selected on screen
    func reservationFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
    func tomorrow()-> Date {
        return Date().changed(day: Date().day + 1)!
    }
    
    // Weekday 9:00AM - 7:00PM - Weekend 11:00AM - 7:00PM local (UTC is -4, Default Date in UTC)
    func oooMessage()-> String? {
        guard let today = self.changed(hour: self.hour - 4) else { return nil }
        
        let start: Date
        let end = Date.init(year: today.year, month: today.month, day: today.day, hour: 15, minute: 0, second: 0)
        
        if today.weekday > 1 && today.weekday < 7 {
            start = Date.init(year: today.year, month: today.month, day: today.day, hour: 5, minute: 0, second: 0)
        } else {
            start = Date.init(year: today.year, month: today.month, day: today.day, hour: 7, minute: 0, second: 0)
        }
        
        if today < start || today > end {
            if today.weekday > 1 && today.weekday < 7 {
                return "Our weekday office hours are 9:30am-7pm, we look forward to following up first thing in the morning"
            } else {
                return "We have a member of the team on standby between 11am-7pm over the weekend, please forgive us in advance for any delays in response time."
            }
        } else {
            return nil
        }
    }
}
