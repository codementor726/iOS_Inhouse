//
//  TextFieldExtensions.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/30/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit

extension UITextField {
    @IBInspectable var placeHolderColor: UIColor {
        get {
            return self.placeHolderColor
        }
        set {
            if let placeholder = placeholder {
                attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor : newValue])
            }
        }
    }
}

extension UILabel {
    func isTruncated(_ oneLineHeight: CGFloat)-> Bool {
        guard let labelText = text else {
            return false
        }
        
        let labelTextSize = (labelText as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedStringKey.font: font],
            context: nil).size
        
        let truncated = labelTextSize.height > oneLineHeight || labelTextSize.width > bounds.size.width
        return truncated
    }
}
