//
//  OnboardingSubmittedViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/11/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit

class OnboardingSubmittedViewController: UIViewController {
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(true, forKey: "IndustryUserSubmitted")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MixpanelHelper.screenView("OnboardingSubmitted")
    }
    
    // MARK: IBAction

    @IBAction func tapOkay(_ sender: UIButton) {
        MixpanelHelper.buttonTap("OnboardingSubmittedOkay")
        transitionToOnboardingStart()
    }
    
    @IBAction func tapNeedHelp(_ sender: UIButton) {
        needHelpEmail()
    }
}

// MARK: Class Func

extension OnboardingSubmittedViewController {
    class func identifier()-> String {
        return "OnboardingSubmittedViewControllerIdentifier"
    }
}
