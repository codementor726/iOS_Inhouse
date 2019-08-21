//
//  InHouseDateTransform.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/11/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import ObjectMapper

open class InHouseDateTransform: TransformType {
    public typealias Object = Date
    public typealias JSON = Double
    
    public init() {}
    
    open func transformFromJSON(_ value: Any?) -> Date? {
        if let timeStr = value as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return dateFormatter.date(from: timeStr)
        }
        return nil
    }
    
    open func transformToJSON(_ value: Date?) -> Double? {
        if let date = value {
            return Double(date.timeIntervalSince1970)
        }
        return nil
    }
}
