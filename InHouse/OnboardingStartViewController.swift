//
//  OnboardingStartViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/8/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit

class OnboardingNavigationController: UINavigationController {
    override func viewDidLoad() {
        setNavigationBarHidden(true, animated: false)
    }
}

class OnboardingStartViewController: UIViewController {
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MixpanelHelper.screenView("OnboardingStart")
    }
    
    // MARK: IBAction
    
    @IBAction func tapIndustry(_ sender: Any) {
        MixpanelHelper.buttonTap("IndustryLogin")
        let industrySubmitted = UserDefaults.standard.value(forKey: "IndustryUserSubmitted") as? Bool
        if industrySubmitted == true {
            transitionToOnboardingPhone()
        } else {
            transitionToOnboardingIndustry(info: nil)
        }
    }

    @IBAction func tapMember(_ sender: Any) {
        MixpanelHelper.buttonTap("MemberLogin")
        transitionToOnboardingPhone()
    }
}

// MARK: Class Func

extension OnboardingStartViewController {
    class func identifier()-> String {
        return "OnboardingStartViewControllerIdentifier"
    }
}
