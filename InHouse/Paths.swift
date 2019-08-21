//
//  Paths.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/11/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

struct Path {
    private static var Base: String {
        get {
            switch Environment.Current {
            case .development:
                return "http://ec2-34-234-232-204.compute-1.amazonaws.com/v1"
            case .production:
                return "https://api.inhousenewyork.com/v1"
            }
        }
    }
    
    // MARK: Signup
    
    struct SignUp {
        public static let PhoneNumber = "\(Base)/device"
        public static let CodeSignIn = "\(Base)/login"
        public static let Form = "\(Base)/signup"
    }
    
    // MARK: Feed
    
    struct Feed {
        static let Posts:(_ page: Int)-> String = { page in
            return "\(Base)/posts?page=\(page)"
        }
        static let Like:(_ id: Int)-> String = { id in
            return "\(Base)/posts/\(id)/like"
        }
    }
    
    // MARK: Restaurant
    
    struct Restaurant {
        static let All:(_ cityId: Int)-> String = { cityId in
            return "\(Base)/restaurants?limit=1000&city_id=\(cityId)"
        }
        static let Details:(_ id: Int)-> String = { id in
            return "\(Base)/restaurants/\(id)"
         }
        static let AvailableInventory:(_ date: String, _ party: Int, _ page: Int, _ query: String?, _ neighborhoodIds: [Int]?)-> String = { date, party, page, query, neighborhoodIds in
            var base = "\(Base)/restaurants/availability?date=\(date)&party_size=\(party)&page=\(page)&city_id=\(currentCity.code)&limit=100"
            
            if let q = query {
                base.append("&q=\(q)")
            }
            if let neighborhoodIds = neighborhoodIds, !neighborhoodIds.isEmpty {
                let ids = neighborhoodIds.map({"\($0)"}).joined(separator: ",")
                base.append("&neighborhood_id=\(ids)")
            }
            return base.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? base
        }
        static let InstantBookings:(_ date: String, _ page: Int)-> String = { date, page in
            let base = "\(Base)/restaurants/availability?date=\(date)&party_size=\(2)&page=\(page)&city_id=\(currentCity.code)&strict=1&limit=100"
            return base.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? base
        }
    }
    
    // MARK: Neighborhoods
    
    struct Neighborhood {
        static let All:()-> String = {
            return "\(Base)/neighborhoods?limit=100&city_id=\(currentCity.code)"
        }
    }
    
    // MARK: Reservations
    
    struct Reservation {
        public static let Past = "\(Base)/my/reservations?limit=100000&time=past"
        public static let Upcoming = "\(Base)/my/reservations?limit=100000&time=upcoming"
        public static let Details = "\(Base)/reservations/id"
        public static let Book = "\(Base)/reservations"
    }
    
    // MARK: Profile
    
    struct Profile {
        public static let Me = "\(Base)/me"
        static let Edit:(_ id: String)-> String = { id in
            return "\(Base)/users/\(id)"
        }
    }
}
