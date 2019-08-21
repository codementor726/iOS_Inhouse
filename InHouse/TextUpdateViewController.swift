//
//  TextUpdateViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/7/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit

class TextUpdateViewController: UIViewController {
    
    // MARK: Variables
    
    var baseString: String?
    var currentType: UpdateTextType = .cancel {
        didSet {
            switch currentType {
            case .cancel:
                cancelButton.configureForCheck()
                changeButton.configureForUncheck()
                enterOwnButton.configureForUncheck()
            case .change:
                cancelButton.configureForUncheck()
                changeButton.configureForCheck()
                enterOwnButton.configureForUncheck()
            case .custom:
                cancelButton.configureForUncheck()
                changeButton.configureForUncheck()
                enterOwnButton.configureForCheck()
            }
        }
    }
    
    enum UpdateTextType {
        case cancel, change, custom
    }
    
    // MARK: IBOutlet
    
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var cancelLabel: UILabel!
    @IBOutlet weak var enterOwnButton: UIButton!
    @IBOutlet weak var enterOwnTextView: UITextView!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let baseString = baseString {
            changeLabel.text = "Hi Em - I need to CANCEL my reservation for \(baseString)"
            cancelLabel.text = "Hi Em - I need to CHANGE my reservation for \(baseString)"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MixpanelHelper.screenView("TextChangelCancelReservation")
    }
    
    // MARK: IBAction
    
    @IBAction func tapCancelText(_ sender: UIButton) {
        currentType = .cancel
    }
    
    @IBAction func tapChangeText(_ sender: UIButton) {
        currentType = .change
    }
    
    @IBAction func tapEnterOwnText(_ sender: UIButton) {
        currentType = .custom
    }
    
    @IBAction func tapText(_ sender: UIButton) {
        switch currentType {
        case .cancel:
            textInHouse(cancelLabel.text)
        case .change:
            textInHouse(changeLabel.text)
        case .custom:
            textInHouse(nil)
        }
    }
    
    @IBAction func tapEmail(_ sender: UIButton) {
        switch currentType {
        case .cancel:
            emailMembershipInHouse(subject: nil, body: cancelLabel.text)
        case .change:
            emailMembershipInHouse(subject: nil, body: changeLabel.text)
        case .custom:
            emailMembershipInHouse(subject: nil, body: nil)
        }
    }
}
