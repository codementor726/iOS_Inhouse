//
//  GrantLocationViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/14/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit
import PermissionScope

class GrantLocationViewController: UIViewController {
    
    // MARK: Variables
    
    lazy var pscope = PermissionScope()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pscope.viewControllerForAlerts = self
        pscope.onAuthChange = { (finished, results) in
            let status = self.pscope.statusLocationInUse()
            if status != .unknown {
                self.transitionToLoggedIn()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MixpanelHelper.screenView("GrantLocation")
    }
    
    // MARK: IBAction
    
    @IBAction func tapGrantAccess(_ sender: UIButton) {
        MixpanelHelper.buttonTap("GrantLocation")
        let status = self.pscope.statusLocationInUse()
        if status == .unknown {
            pscope.requestLocationInUse()
        } else {
            transitionToLoggedIn()
        }
    }
    
    @IBAction func tapDecline(_ sender: UIButton) {
        MixpanelHelper.buttonTap("DeclineLocation")
        transitionToLoggedIn()
    }
}

// MARK: Class Func

extension GrantLocationViewController {
    class func identifier()-> String {
        return "GrantLocationViewControllerIdentifier"
    }
}
