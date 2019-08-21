//
//  Timeslot.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/23/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import ObjectMapper

class Timeslot: Mappable {
    var id: Int!
    var time: String!
    var tableType: String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        id <- map["timeslot_id"]
        time <- map["time"]
        tableType <- map["table_type"]
    }
}
