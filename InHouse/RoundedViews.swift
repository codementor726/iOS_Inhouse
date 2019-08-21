//
//  RoundedButton.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/21/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    @IBInspectable var cleanCorner: CGFloat = 0
    @IBInspectable var cleanBackgroundColor: UIColor = .white
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cleanCorner)
        titleLabel?.backgroundColor = cleanBackgroundColor
        cleanBackgroundColor.set()
        path.fill()
    }
}

class RoundedView: UIView {
    
    @IBInspectable var cleanCorner: CGFloat = 0
    @IBInspectable var cleanBackgroundColor: UIColor = .white
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cleanCorner)
        cleanBackgroundColor.set()
        path.fill()
    }
}
