//
//  ContactViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/13/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {
    
    // MARK: Variables
    
    fileprivate var currentType: UpdateType = .recommend {
        didSet {
            switch currentType {
            case .learn:
                learnButton.configureForCheck()
                recommendButton.configureForUncheck()
                enterOwnButton.configureForUncheck()
            case.recommend:
                learnButton.configureForUncheck()
                recommendButton.configureForCheck()
                enterOwnButton.configureForUncheck()
            case .custom:
                learnButton.configureForUncheck()
                recommendButton.configureForUncheck()
                enterOwnButton.configureForCheck()
            }
        }
    }
    fileprivate enum UpdateType {
        case learn, recommend, custom
    }
    
    // MARK: IBOutlet
    
    @IBOutlet weak var learnButton: UIButton!
    @IBOutlet weak var learnLabel: UILabel!
    @IBOutlet weak var recommendButton: UIButton!
    @IBOutlet weak var recommendLabel: UILabel!
    @IBOutlet weak var enterOwnButton: UIButton!
    @IBOutlet weak var enterOwnTextView: UITextView!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "INHOUSE"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MixpanelHelper.screenView("ContactInHouse")
    }
    
    // MARK: IBAction
    
    @IBAction func tapLearn(_ sender: UIButton) {
        currentType = .learn
    }
    
    @IBAction func tapRecommend(_ sender: UIButton) {
        currentType = .recommend
    }
    
    @IBAction func tapEnterOwnText(_ sender: UIButton) {
        currentType = .custom
    }
    
    @IBAction func tapContactViaText(_ sender: UIButton) {
        MixpanelHelper.buttonTap("ContactInHouseText")
        switch currentType {
        case .learn:
            textInHouse(learnLabel.text)
        case.recommend:
            textInHouse(recommendLabel.text)
        case .custom:
            textInHouse(nil)
        }
    }
    
    @IBAction func tapContactViaEmail(_ sender: UIButton) {
        MixpanelHelper.buttonTap("ContactInHouseEmail")
        switch currentType {
        case .learn:
            emailMembershipInHouse(subject: nil, body: learnLabel.text)
        case.recommend:
            emailMembershipInHouse(subject: nil, body: recommendLabel.text)
        case .custom:
            emailMembershipInHouse(subject: nil, body: nil)
        }
    }
    
    @IBAction func tapSettings(_ sender: UIBarButtonItem) {
        presentSettings()
    }
}
