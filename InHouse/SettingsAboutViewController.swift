//
//  SettingsAboutViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 9/1/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit

class SettingsAboutViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MixpanelHelper.screenView("AboutInHouse")
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
