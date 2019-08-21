//
//  InHouseAPI.shared.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/14/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

final class InHouseAPI {
    
    // MARK: Variables
    
    public static let shared = InHouseAPI()
    var newsFeedPageInfo: PageInfo?
    var availabilityPageInfo: PageInfo?
    var instantBookingsPageInfo: PageInfo?
    
    // MARK: Init
    
    private init() { }
    
    // MARK: Header
    
    fileprivate func authHeaders() -> [String: String] {
        return ["Authorization": "Bearer \(CurrentUser().apiKey())", "Accept": "application/json"]
    }
    
    // MARK: Completion Generator
    
    fileprivate struct CompletionGenerator<T> {
        var success: Bool
        var object: T?
        var error: String?
        
        init(result: Result<ServerResponse>, object: T?) {
            switch result {
            case .success(_):
                self.success = result.value?.success ?? (object != nil)
                self.object = object
                self.error = result.value?.message
            case .failure(_):
                self.success = false
                self.object = nil
                self.error = result.value?.message ?? result.error?.localizedDescription ?? "Connection Error"
            }
        }
    }
}

// MARK: Sign Up

extension InHouseAPI {
    public func phoneNumberSignUp(_ phone: String, completion: @escaping NetworkCompletionHandler<User>) {
        let parameters: [String: Any] = ["phone" : phone,
                                         "client_id" : clientId(),
                                         "client_secret" : clientSecret(),
                                         "grant_type" : "password"]
        
        SessionManager.default.request(Path.SignUp.PhoneNumber, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseObject { (response: DataResponse<ServerResponse>) in
            let response = CompletionGenerator.init(result: response.result, object: response.result.value?.user)
            completion(response.success, response.object, response.error)
        }
    }
    
    public func codeSignIn(_ code: String, phone: String, completion: @escaping NetworkCompletionHandler<User>) {
        let parameters: [String: Any] = ["code" : code,
                                         "phone" : phone,
                                         "client_id" : clientId(),
                                         "client_secret" : clientSecret(),
                                         "grant_type" : "password"]
        
        SessionManager.default.request(Path.SignUp.CodeSignIn, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseObject { (response: DataResponse<ServerResponse>) in
            let response = CompletionGenerator.init(result: response.result, object: response.result.value?.user)
            completion(response.success, response.object, response.error)
        }
    }
    
    public func industryFormSignUp(requiredInfo: RequiredIndustrySignup, spouse: String?, anniversary: String?, allergies: String, cocktails: String, formerPositions: String, completion: @escaping NetworkCompletionHandler<User>) {
        let parameters: [String: Any] = ["first_name" : requiredInfo.first,
                                         "last_name" : requiredInfo.last,
                                         "email" : requiredInfo.email,
                                         "phone" : "\(requiredInfo.countryCode.rawNumber)\(requiredInfo.phone)",
                                         "type" : "industry",
                                         "restaurant_name" : requiredInfo.restaurant,
                                         "position_at_restaurant" : requiredInfo.position,
                                         "partner_name" : spouse ?? NSNull(),
                                         "anniversary" : anniversary ?? NSNull(),
                                         "allergies" : allergies,
                                         "favorite_drink" : cocktails,
                                         "former_position" : formerPositions,
                                         "client_id" : clientId(),
                                         "client_secret" : clientSecret(),
                                         "grant_type" : "password"]
        
        SessionManager.default.request(Path.SignUp.Form, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseObject { (response: DataResponse<ServerResponse>) in
            let response = CompletionGenerator.init(result: response.result, object: response.result.value?.user)
            completion(response.success, response.object, response.error)
        }
    }
}

// MARK: Reservations

extension InHouseAPI {
    public func getMyPastReservations(completion: @escaping NetworkCompletionHandler<[Reservation]>) {
        SessionManager.default.request(Path.Reservation.Past, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: authHeaders()).responseObject { (response: DataResponse<ServerResponse>) in
            let response = CompletionGenerator.init(result: response.result, object: response.result.value?.reservations)
            completion(response.success, response.object, response.error)
        }
    }
    
    public func getMyUpcomingReservations(completion: @escaping NetworkCompletionHandler<[Reservation]>) {
        SessionManager.default.request(Path.Reservation.Upcoming, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: authHeaders()).responseObject { (response: DataResponse<ServerResponse>) in
            let response = CompletionGenerator.init(result: response.result, object: response.result.value?.reservations)
            completion(response.success, response.object, response.error)
        }
    }
    
    public func getFirstUpcomingReservation(completion: @escaping NetworkCompletionHandler<Reservation>) {
        SessionManager.default.request(Path.Reservation.Upcoming, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: authHeaders()).responseObject { (response: DataResponse<ServerResponse>) in
            let response = CompletionGenerator.init(result: response.result, object: response.result.value?.reservations?.first)
            completion(response.success, response.object, response.error)
        }
    }
    
    public func bookReservation(restaurantId: Int, date: String, timeslotId: Int, partySize: Int, comments: String?, completion: @escaping NetworkCompletionHandler<Reservation>) {
        let parameters: [String: Any] = ["user_id" : CurrentUser().id(),
                                         "restaurant_id" : restaurantId,
                                         "date" : date,
                                         "timeslot_id": timeslotId,
                                         "party_size" : partySize,
                                         "comments" : comments ?? NSNull(),
                                         "version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "missing"]
        
        SessionManager.default.request(Path.Reservation.Book, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: authHeaders()).responseObject { (response: DataResponse<ServerResponse>) in
            let response = CompletionGenerator.init(result: response.result, object: response.result.value?.reservation)
            completion(response.success, response.object, response.error)
        }
    }
    
    public func requestReservation(restaurantId: Int, date: String, prefTime: Date, minTime: Date, maxTime: Date,  partySize: Int, commments: String?, completion: @escaping NetworkCompletionHandler<Reservation>) {
        let parameters: [String: Any] = ["user_id" : CurrentUser().id(),
                                         "restaurant_id" : restaurantId,
                                         "date" : date,
                                         "preferred_time": prefTime.reservationFormat(),
                                         "min_time" : minTime.reservationFormat(),
                                         "max_time" : maxTime.reservationFormat(),
                                         "party_size" : partySize,
                                         "comments" : commments ?? NSNull(),
                                         "version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "missing"]
        
        SessionManager.default.request(Path.Reservation.Book, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: authHeaders()).responseObject { (response: DataResponse<ServerResponse>) in
            let response = CompletionGenerator.init(result: response.result, object: response.result.value?.reservation)
            completion(response.success, response.object, response.error)
        }
    }
}

// MARK: Restaurants

extension InHouseAPI {
    public func getAvailability(initial: Bool, date: String, partySize: Int, query: String?, neighborhoodIds: [Int]?, completion: @escaping NetworkCompletionHandler<[AvailableInventoryItem]>) {
        if initial {
            availabilityPageInfo = nil
        } else if availabilityPageInfo?.hasNextPage() == false {
            completion(true, nil, "Last Page")
            return
        }
        
        let page = availabilityPageInfo != nil ? availabilityPageInfo!.page + 1 : 1
        
        SessionManager.default.request(Path.Restaurant.AvailableInventory(date, partySize, page, query, neighborhoodIds), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: authHeaders()).responseObject { (response: DataResponse<ServerResponse>) in
            self.availabilityPageInfo = response.result.value?.pageInfo
            let response = CompletionGenerator.init(result: response.result, object: response.result.value?.availableInventoryItems)
            completion(response.success, response.object, response.error)
        }
    }
    
    public func getInstantBookings(initial: Bool, date: String, completion: @escaping NetworkCompletionHandler<[AvailableInventoryItem]>) {
        if initial {
            instantBookingsPageInfo = nil
        } else if instantBookingsPageInfo?.hasNextPage() == false {
            completion(true, nil, "Last Page")
            return
        }
        
        let page = instantBookingsPageInfo != nil ? instantBookingsPageInfo!.page + 1 : 1
        
        SessionManager.default.request(Path.Restaurant.InstantBookings(date, page), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: authHeaders()).responseObject { (response: DataResponse<ServerResponse>) in
            self.instantBookingsPageInfo = response.result.value?.pageInfo
            let response = CompletionGenerator.init(result: response.result, object: response.result.value?.availableInventoryItems)
            completion(response.success, response.object, response.error)
        }
    }
}

// MARK: News

extension InHouseAPI {
    public func getNewsFeed(initial: Bool,completion: @escaping NewsFeedCompletionHandler) {
        if initial {
            newsFeedPageInfo = nil
        } else if newsFeedPageInfo?.hasNextPage() == false {
            completion(true, nil, false, "Last Page")
            return
        }
        
        let page = (newsFeedPageInfo != nil) ? newsFeedPageInfo!.page + 1 : 1
        SessionManager.default.request(Path.Feed.Posts(page), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: authHeaders()).responseObject { (response: DataResponse<ServerResponse>) in
            self.newsFeedPageInfo = response.result.value?.pageInfo
            let response = CompletionGenerator.init(result: response.result, object: response.result.value?.newsFeedItems)
            completion(response.success, response.object, self.newsFeedPageInfo?.showFeatured ?? false, response.error)
        }
    }
    
    public func toggleNewsFeedItemLike(_ id: Int, completion: @escaping NetworkCompletionHandler<NewsFeedItem>) {
        SessionManager.default.request(Path.Feed.Like(id), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: authHeaders()).responseObject { (response: DataResponse<ServerResponse>) in
            let response = CompletionGenerator.init(result: response.result, object: response.result.value?.newsFeedItem)
            completion(response.success, response.object, response.error)
        }
    }
}

// MARK: Profile

extension InHouseAPI {
    public func getMyProfile(completion: @escaping NetworkCompletionHandler<User>) {
        SessionManager.default.request(Path.Profile.Me, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: authHeaders()).responseObject { (response: DataResponse<ServerResponse>) in
            let response = CompletionGenerator.init(result: response.result, object: response.result.value?.user)
            completion(response.success, response.object, response.error)
        }
    }
    
    public func editUser(fields: [String: Any], completion: @escaping NetworkCompletionHandler<User>) {
        SessionManager.default.request(Path.Profile.Edit(CurrentUser().id()), method: .patch, parameters: fields, encoding: JSONEncoding.default, headers: authHeaders()).responseObject { (response: DataResponse<ServerResponse>) in
            let response = CompletionGenerator.init(result: response.result, object: response.result.value?.user)
            completion(response.success, response.object, response.error)
        }
    }
}

// MARK: Neighborhoods

extension InHouseAPI {
    public func getNeighborhoods(completion: @escaping NetworkCompletionHandler<[Neighborhood]>) {
        SessionManager.default.request(Path.Neighborhood.All(), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: authHeaders()).responseObject { (response: DataResponse<ServerResponse>) in
            let response = CompletionGenerator.init(result: response.result, object: response.result.value?.neighborhoods)
            completion(response.success, response.object, response.error)
        }
    }
}

// MARK: Auth Helper

extension InHouseAPI {
    fileprivate func clientId() -> String {
        switch Environment.Current {
        case .development:
            return "3"
        case .production:
            return "1"
        }
    }
    
    fileprivate func clientSecret() -> String {
        switch Environment.Current {
        case .development:
            return "3zUnfo8bEGale36lZinL3gvagM80B1JDufp7IXNc"
        case .production:
            return "rqp1TwulL5vvGtH0mgEDi2ygB6M9QcrOyoE0fwIi"
        }
    }
}
