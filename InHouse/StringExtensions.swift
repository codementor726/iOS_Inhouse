//
//  StringExtensions.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/30/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import Foundation

// MARK: - Date Formatting

extension String {
    func convertApiDateString(_ format: String)-> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: self)
        return date?.stringWithFormat(format)
    }
    
    func convertToDate(format: String)-> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
    
    func convertApiDateStringToDate()-> Date? {
        return convertToDate(format: "yyyy-MM-dd")
    }
    
    func convertFormattedDateStringToApi(_ format: String)-> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date?.apiString()
    }
    
    func covertFormattedStringToDate(_ format: String)-> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
}

// MARK: - Int Formatting

extension String {
    func int()-> Int? {
        let intString = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression, range: nil)
        return Int(intString)
    }
    
    func intString()-> String? {
        let intString = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression, range: nil)
        return intString
    }
}
