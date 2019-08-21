//
//  ButtonExtensions.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/30/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit

extension UIButton {
    func reverseButtonImage() {
        transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    
    func configureForCheck() {
        backgroundColor = Colors.OffRed
        borderColor = Colors.OffRed
    }
    
    func configureForUncheck() {
        backgroundColor = .white
        borderColor = .lightGray
    }
}
