//
//  Appearance.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/24/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit

struct Appearance {
    public static func setup() {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: Fonts.FreightDispPro.Medium(24), NSAttributedStringKey.foregroundColor: Colors.OffWhite]
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = Colors.OffWhite
        UINavigationBar.appearance().barTintColor = Colors.DarkBlue
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for:.default)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: Fonts.Colfax.Regular(16), NSAttributedStringKey.foregroundColor: Colors.OffWhite], for: .normal)
        
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().tintColor = Colors.DarkBlue
        UITabBar.appearance().barTintColor = .white
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font : Fonts.Colfax.Medium(10)], for: .normal)
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
    }
}
