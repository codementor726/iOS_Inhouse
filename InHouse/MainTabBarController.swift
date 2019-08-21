//
//  MainTabBarController.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/17/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit

enum Tabs {
    case news, restaurants, contact
}

class MainTabBarController: UITabBarController {
    
    // MARK: Variables
    
    var previousIndex: Int?
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self 
        NotificationCenter.default.addObserver(forName: .switchToContact,
                                               object:nil, queue:nil,
                                               using:catchNotification(notification:))
    }
    
    // MARK: Notification
    
    private func catchNotification(notification: Notification) -> Void {
        selectedIndex = 2
    }
}

// MARK: UITabBarControllerDelegate

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if selectedIndex == Tabs.news.hashValue, previousIndex == selectedIndex {
            NotificationCenter.default.post(name: .scrollToTop, object: nil)
        }
        if selectedIndex == Tabs.restaurants.hashValue, previousIndex == selectedIndex {
            (viewControllers?[1] as? UINavigationController)?.navigationBar.barTintColor = Colors.DarkBlue
        }
        previousIndex = selectedIndex
    }
}
