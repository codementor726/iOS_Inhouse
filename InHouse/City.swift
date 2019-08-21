//
//  City.swift
//  InHouse
//
//  Created by Kevin Johnson on 9/8/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import Foundation
import CoreLocation

var currentCity: City = load() ?? cities.first! {
    didSet {
        UserDefaults.standard.set(currentCity.code, forKey: "CurrentCity")
    }
}

let cities: [City] = [(City.init(name: "New York", code: 1, center: CLLocationCoordinate2D.init(latitude: 40.739125, longitude: -73.987266), zoom: 11.7)),
                      (City.init(name: "London", code: 2, center: CLLocationCoordinate2D.init(latitude: 51.51349, longitude: -0.1011266), zoom: 10.8))]

struct City {
    var name: String
    var code: Int
    var center: CLLocationCoordinate2D
    var zoom: Double

    init(name: String, code: Int, center: CLLocationCoordinate2D, zoom: Double = 12.0) {
        self.name = name
        self.code = code
        self.center = center
        self.zoom = zoom
    }
}

private func load()-> City? {
    guard let currentInt = UserDefaults.standard.value(forKey: "CurrentCity") as? Int else { return nil }
    if currentInt == 1 {
        return cities.first
    } else if currentInt == 2 {
        return cities[1]
    } else {
        return nil
    }
}
  
