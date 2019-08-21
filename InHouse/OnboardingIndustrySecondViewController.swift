//
//  OnboardingIndustrySecondViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/23/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit
import IQKeyboardManager

class OnboardingIndustrySecondViewController: UIViewController {
    
    // MARK: Variable
    
    var handler: IQKeyboardReturnKeyHandler?
    var requiredInfo: RequiredIndustrySignup? // nonoptional vc props need, don't want this as optional..
    
    // MARK: IBOutlet/UI
    
    @IBOutlet weak fileprivate var partnertNameTextField: UITextField!
    @IBOutlet weak fileprivate var anniversaryTextField: UITextField!
    lazy var anniversaryPicker = UIDatePicker()
    @IBOutlet weak fileprivate var allergiesTextView: UITextView!
    @IBOutlet weak fileprivate var drinksTextView: UITextView!
    @IBOutlet weak fileprivate var formerPositionsTextView: UITextView!
    @IBOutlet weak var submitButton: LoadingButton!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handler = IQKeyboardReturnKeyHandler.init(viewController: self)
        handler!.lastTextFieldReturnKeyType = .done
        
        anniversaryPicker.datePickerMode = .date
        anniversaryPicker.maximumDate = Date()
        if let anniversary: Date = CurrentUser().anniversary()?.convertApiDateStringToDate() {
            anniversaryPicker.date = anniversary
        }
        anniversaryTextField.inputView = anniversaryPicker
        anniversaryPicker.addTarget(self, action: #selector(anniversaryChanged), for: .valueChanged)
        
        allergiesTextView.shouldHideToolbarPlaceholder = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MixpanelHelper.screenView("OnboardingIndustrySecond")
    }
    
    // MARK: Change
    
    @objc func anniversaryChanged() {
        let date = anniversaryPicker.date
        anniversaryTextField.text = date.stringWithFormat("MMM d, yyyy")
    }

    // MARK: Sign Up
    
    func signUp() {
        guard let required = requiredInfo else { assertionFailure()
            return
        }
        
        submitButton.showLoading()
        InHouseAPI.shared.industryFormSignUp(requiredInfo: required, spouse: partnertNameTextField.text, anniversary: anniversaryTextField.text?.convertFormattedDateStringToApi("MMM d, yyyy"), allergies: allergiesTextView.text, cocktails: drinksTextView.text, formerPositions: formerPositionsTextView.text) { (success, user, error)-> Void in
            self.submitButton.hideLoading()
            if success {
                MixpanelHelper.setUser(name: "\(required.first) \(required.last)", email: required.email)
                self.transitionToOnboardingSubmited()
            } else {
                self.showMessage(error ?? "Error Submiting Application", title: "Error")
            }
        }
    }
    
    // MARK: IBAction
    
    @IBAction func tapSubmit(_ sender: UIButton) {
        MixpanelHelper.buttonTap("OnboardingIndustrySubmit")
        validSignUp() { validation in
            if validation.valid {
                self.signUp()
            } else {
                self.showMessage(nil, title: validation.message)
            }
            
        }
    }
    
    @IBAction func tapBack(_ sender: UIButton) {
        transitionToOnboardingIndustry(info: requiredInfo)
    }
    
    @IBAction func tapCancel(_ sender: UIButton) {
        transitionToOnboardingStart()
    }
    
    @IBAction func tapNeedHelp(_ sender: UIButton) {
        needHelpEmail()
    }
}

// MARK: Validation

extension OnboardingIndustrySecondViewController {
    func validSignUp(completion: @escaping (ValidationReturn)-> Void) {
        let allergiesValidation = Validation.validString(allergiesTextView.text, emptyMessage: "Allergies Empty")
        let drinksValidation = Validation.validString(drinksTextView.text, emptyMessage: "Favourite Cocktails/Wines Empty")
        let positionsValidation = Validation.validString(formerPositionsTextView.text, emptyMessage: "Former Positions Empty")
        
        let validations = [allergiesValidation, drinksValidation, positionsValidation]
        for validation in validations {
            if !validation.valid || validation == validations.last {
                completion(validation)
                return
            }
        }
    }
}

// MARK: Class Func

extension OnboardingIndustrySecondViewController {
    class func identifier()-> String {
        return "OnboardingIndustrySecondViewControllerIdentifier"
    }
}
