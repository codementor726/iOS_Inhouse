//
//  Environment.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/11/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

struct Environment {
    public static let Current: Types = .production
    
    enum Types {
        case production, development
    }
}
