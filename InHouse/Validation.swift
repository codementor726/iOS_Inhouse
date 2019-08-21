//
//  InHoueValidation.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/14/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import SwiftValidators

struct ValidationReturn {
    var valid: Bool
    var message: String?
    
    init(valid: Bool, message: String?) {
        self.valid = valid
        self.message = message
    }
}

extension ValidationReturn: Equatable {
    static func ==(lhs: ValidationReturn, rhs: ValidationReturn) -> Bool {
        return lhs.message == rhs.message && lhs.valid == rhs.valid
    }
}

class Validation {
    
    // MARK: General
    
    public static func validMaxCharString(_ string: String?, emptyMessage: String?, maxMessage: String?)-> ValidationReturn {
        if Validator.isEmpty().apply(string) {
            return ValidationReturn(valid: false, message: emptyMessage)
        }
        if !Validator.maxLength(255).apply(string) {
            return ValidationReturn(valid: false, message: maxMessage)
        }
        return ValidationReturn(valid: true, message: nil)
    }
    
    public static func validString(_ string: String?, emptyMessage: String?)-> ValidationReturn {
        if Validator.isEmpty().apply(string) {
            return ValidationReturn(valid: false, message: emptyMessage)
        }
        return ValidationReturn(valid: true, message: nil)
    }
    
    public static func validDateString(_ string: String?, invalidMessage: String?)-> ValidationReturn {
        if string?.covertFormattedStringToDate("MMM d, yyyy") == nil {
            return ValidationReturn(valid: false, message: invalidMessage)
        }
        return ValidationReturn(valid: true, message: nil)
    }
    
    // MARK: Specialized
    
    public static func validEmail(_ email: String?)-> ValidationReturn {
        if Validator.isEmpty().apply(email) {
            return ValidationReturn(valid: false, message: Message.EmailEmpty)
        }
        if !Validator.isEmail().apply(email) {
            return ValidationReturn(valid: false, message: Message.EmailInvalid)
        }
        if !Validator.maxLength(255).apply(email) {
            return ValidationReturn(valid: false, message: Message.EmailMaxChar)
        }
        return ValidationReturn(valid: true, message: nil)
    }
    
    public static func validPhone(_ phone: String?)-> ValidationReturn {
        if Validator.isEmpty().apply(phone) {
            return ValidationReturn(valid: false, message: Message.PhoneEmpty)
        }
        return ValidationReturn(valid: true, message: nil)
    }
    
    public static func validCode(_ code: Int?)-> ValidationReturn {
        if Validator.isEmpty().apply(code) {
            return ValidationReturn(valid: false, message: Message.CodeEmpty)
        }
        if !Validator.isNumeric().apply(code) {
            return ValidationReturn(valid: false, message: Message.CodeInvalid)
        }
        return ValidationReturn(valid: true, message: nil)
    }

    // MARK: Message
    
    public struct Message {
        public static let FirstNameEmpty = "First Name Empty"
        public static let FirstNameMaxChar = "First Name Too Long"
        public static let LastNameEmpty = "Last Name Empty"
        public static let LastNameMaxChar = "Last Name Too Long"
        
        public static let EmailEmpty = "Email Empty"
        public static let EmailInvalid = "Email Invalid"
        public static let EmailMaxChar = "Email Too Long"
        
        public static let PhoneEmpty = "Phone Empty"
        public static let PhoneInvalid = "Phone Number Invalid"
        
        public static let CodeEmpty = "Code Empty"
        public static let CodeInvalid = "Code Invalid"
        
        public static let RestaurantEmpty = "Restaurant Empty"
        public static let PositionEmpty = "Position Empty"
        public static let SpouseEmpty = "Spouse Empty"
        public static let AllergiesEmpty = "Allergies Empty"
        public static let AnniversaryEmpty = "Anniversary Empty"
        public static let BirthdayEmpty = "Birthday Empty"
        
        public static let AnniversaryInvalid = "Anniversary Invalid"
        public static let BirthdayInvalid = "Birthday Invalid"
    }
}
