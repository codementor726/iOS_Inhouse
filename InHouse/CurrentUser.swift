//
//  CurrentUser.swift
//
//
//  Created by Kevin Johnson on 1/6/17.
//  Copyright © 2017 Majestyk Apps. All rights reserved.
//

import Foundation

struct CurrentUser {
    
    // MARK: Get
    
    public func getValue<T>(_ key: String) -> T? {
        switch T.self {
        case is Bool.Type:
            return UserDefaults.standard.bool(forKey: key) as? T
        case is String.Type:
            return UserDefaults.standard.string(forKey: key) as? T
        case is Int.Type:
            return UserDefaults.standard.integer(forKey: key) as? T
        default:
            return nil
        }
    }
    
    // MARK: Set
    
    public func set(_ user: User) {
        resetUser()
        setValue(user.id, key: Keys.User.ID)
        setValue(user.tokens?.access, key: Keys.User.APIKey)
        setValue(user.firstName, key: Keys.User.First)
        setValue(user.lastName, key: Keys.User.Last)
        setValue(user.type, key: Keys.User.Industry)
        setValue(user.email, key: Keys.User.Email)
        setValue(user.phone, key: Keys.User.Phone)
        setValue(user.birthday, key: Keys.User.Birthday)
        setValue(user.partnerName, key: Keys.User.SpouseName)
        setValue(user.anniversary, key: Keys.User.Anniversary)
        setValue(user.allergies, key: Keys.User.Allergies)
        setValue(user.favoriteDrinks, key: Keys.User.Drinks)
        if user.type == "industry" {
            setValue(user.restauranName, key: Keys.User.Restaurant)
            setValue(user.restaurantPosition, key: Keys.User.Position)
            setValue(user.formerPositions, key: Keys.User.FormerPositions)
        }
    }
    
    public func setValue<T>(_ value: T?, key: String) {
        if let value = value {
            UserDefaults.standard.set(value, forKey: key)
        }
    }
    
    public func removeKey(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    // MARK: Login/Out
    
    func loggedIn() -> Bool {
        return apiKey().replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(null)", with: "").count > 0
    }
    
    func resetUser() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
    }
}

// MARK: Helper Get

extension CurrentUser {
    public func apiKey() -> String {
        return getValue(Keys.User.APIKey) ?? ""
    }
    
    public func id()-> String {
        return getValue(Keys.User.ID)!
    }
    
    public func firstName()-> String {
        return getValue(Keys.User.First) ?? ""
    }
    
    public func name()-> String {
        let first = getValue(Keys.User.First) ?? ""
        let last = getValue(Keys.User.Last) ?? ""
        return "\(first) \(last)"
    }
    
    public func type()-> String? {
        return getValue(Keys.User.Industry)
    }
    
    public func email()-> String? {
        return getValue(Keys.User.Email)
    }
    
    public func phone()-> String? {
        return getValue(Keys.User.Phone)
    }
    
    public func anniversary()-> String? {
        return getValue(Keys.User.Anniversary)
    }
    
    public func birthday()-> String? {
        return getValue(Keys.User.Birthday)
    }
    
    public func spouseName()-> String? {
        return getValue(Keys.User.SpouseName)
    }
    
    public func allergies()-> String? {
        return getValue(Keys.User.Allergies)
    }
    
    public func restaurant()-> String? {
        return getValue(Keys.User.Restaurant)
    }
    
    public func position()-> String? {
        return getValue(Keys.User.Position)
    }
    
    public func drinks()-> String? {
        return getValue(Keys.User.Drinks)
    }
    
    public func formerPositions()-> String? {
        return getValue(Keys.User.FormerPositions)
    }
}
