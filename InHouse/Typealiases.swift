//
//  Typealiases.swift
//  InHouse
//
//  Created by Kevin Johnson on 3/6/18.
//  Copyright © 2018 Kevin Johnson. All rights reserved.
//

import Foundation

typealias NetworkCompletionHandler<T> = (_ success: Bool, _ object: T?, _ error: String?)-> Void
typealias NewsFeedCompletionHandler = (_ success: Bool, _ newsItems: [NewsFeedItem]?, _ showFeatured: Bool, _ error: String?)-> Void
typealias RequiredIndustrySignup = (first: String, last: String, restaurant: String, position: String, email: String, countryCode: CountryCode, phone: String)
