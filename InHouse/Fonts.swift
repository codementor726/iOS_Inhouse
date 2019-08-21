//
//  Fonts.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/24/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit

struct Fonts {
    struct Colfax {
        static let Medium:(_ size: CGFloat) -> UIFont = { size in
            return UIFont.init(name: "Colfax-Medium", size: size)!
        }
        static let Regular:(_ size: CGFloat) -> UIFont = { size in
            return UIFont.init(name: "Colfax-Regular", size: size)!
        }
        static let Bold:(_ size: CGFloat) -> UIFont = { size in
            return UIFont.init(name: "Colfax-Bold", size: size)!
        }
    }
    
    struct FreightDispPro {
        static let Medium:(_ size: CGFloat) -> UIFont = { size in
            return UIFont.init(name: "FreightDispProMedium-Regular", size: size)!
        }
    }
}
