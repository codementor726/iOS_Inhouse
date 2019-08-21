//
//  AppDelegate.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/11/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit
import AlamofireNetworkActivityLogger
import Fabric
import Crashlytics
import IQKeyboardManager
import Harpy
import Mixpanel

@UIApplicationMain
class AppDelegate: UIResponder {
    
    // MARK: - Variables
    
    var window: UIWindow?
    weak var loggedInController: UIViewController?
    weak var onboardingController: UIViewController?
}

// MARK: - UIApplicationDelegate

extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Appearance.setup()
        Fabric.with([Crashlytics.self])
        Mixpanel.initialize(token: "b28b15f12827b73dab7389f747167d64")
        Mixpanel.mainInstance().identify(distinctId: Mixpanel.mainInstance().distinctId)
        NetworkActivityLogger.shared.startLogging()
        NetworkActivityLogger.shared.level = .debug
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        Harpy.sharedInstance().alertType = .force
        
        window?.rootViewController = UIStoryboard.init(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        if CurrentUser().loggedIn() {
            showLoggedIn()
        } else {
            showOnboarding()
        }
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        delayOnMainThread(2.5) {
            Harpy.sharedInstance().presentingViewController = self.loggedInController ?? self.onboardingController
            Harpy.sharedInstance().checkVersionDaily()
        }
    }
}

// MARK: - Presentation

extension AppDelegate {
    private func showOnboarding() {
        delayOnMainThread(2.0) {
            let onboarding = UIStoryboard.init(name: "Onboarding", bundle: nil).instantiateInitialViewController()
            self.onboardingController = onboarding
            self.window?.rootViewController = onboarding
            
        }
    }
    
    private func showLoggedIn() {
        delayOnMainThread(2.0) {
            let main = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()
            self.loggedInController = main
            self.window?.rootViewController = main
        }
    }
}

// MARK: - Logout

extension AppDelegate {
    public func unauthLogout() {
        CurrentUser().resetUser()
        delayOnMainThread(0.5) {
            let onboarding = UIStoryboard.init(name: "Onboarding", bundle: nil).instantiateInitialViewController()
            self.onboardingController = onboarding
            UIView.transition(with: self.window!, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                self.window?.rootViewController = onboarding
            })
        }
    }
}
