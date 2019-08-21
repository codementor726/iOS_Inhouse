//
//  OnboardingIndustryViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/17/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit
import IQKeyboardManager

class OnboardingIndustryViewController: UIViewController {
    
    // MARK: Variable
    
    var handler: IQKeyboardReturnKeyHandler?
    var info: RequiredIndustrySignup?
    
    // MARK: IBOutlet/UI
    
    @IBOutlet weak fileprivate var firstNameTextField: UITextField!
    @IBOutlet weak fileprivate var lastNameTextField: UITextField!
    @IBOutlet weak fileprivate var emailTextField: UITextField!
    @IBOutlet weak fileprivate var phoneTextField: UITextField!
    @IBOutlet weak fileprivate var restaurantTextField: UITextField!
    @IBOutlet weak fileprivate var positionTextField: UITextField!
    @IBOutlet weak fileprivate var countryTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    lazy var countryCodePicker: CountryCodePicker = CountryCodePicker()
    var countryCode: CountryCode? {
        didSet {
            if let countryCode = countryCode {
                countryTextField.text = countryCode.description
            }
        }
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handler = IQKeyboardReturnKeyHandler.init(viewController: self)
        handler!.lastTextFieldReturnKeyType = .done
        
        phoneTextField.delegate = self
        countryTextField.delegate = self
        countryTextField.inputView = countryCodePicker
        countryCodePicker.delegate = countryCodePicker
        countryCodePicker.countryDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MixpanelHelper.screenView("OnboardingIndustry")
        if let info = info {
            firstNameTextField.text = info.first
            lastNameTextField.text = info.last
            emailTextField.text = info.email
            countryCode = info.countryCode
            phoneTextField.text = info.phone
            restaurantTextField.text = info.restaurant
            positionTextField.text = info.position
        }
    }
    
    // MARK: Next
    
    func nextStep() {
        guard let first = firstNameTextField.text, let last = lastNameTextField.text, let email = emailTextField.text, let restaurant = restaurantTextField.text, let position = positionTextField.text, let code = countryCode, let phone = phoneTextField.text else {
            assertionFailure()
            return
        }
        let requiredInfo = RequiredIndustrySignup(first, last, restaurant, position, email, code, phone)
        transitionToOnboardingSecond(requiredInfo)
    }
    
    // MARK: IBAction
    
    @IBAction func tapNext(_ sender: UIButton) {
        MixpanelHelper.buttonTap("OnboardingIndustryNext")
        validSignUp() { validation in
            if validation.valid {
                self.nextStep()
            } else {
                self.showMessage(nil, title: validation.message)
            }
        }
    }
    
    @IBAction func tapCancel(_ sender: UIButton) {
        transitionToOnboardingStart()
    }
    
    @IBAction func tapNeedHelp(_ sender: UIButton) {
        needHelpEmail()
    }
}

// MARK: Validation

extension OnboardingIndustryViewController {
    func validSignUp(completion: @escaping (ValidationReturn)-> Void) {
        let firstValidation = Validation.validMaxCharString(firstNameTextField.text, emptyMessage: Validation.Message.FirstNameEmpty, maxMessage: Validation.Message.LastNameEmpty)
        let lastValidation = Validation.validMaxCharString(lastNameTextField.text, emptyMessage: Validation.Message.LastNameEmpty, maxMessage: Validation.Message.LastNameMaxChar)
        let restaurantValidation = Validation.validString(restaurantTextField.text, emptyMessage: Validation.Message.RestaurantEmpty)
        let positionValidation = Validation.validString(positionTextField.text, emptyMessage: Validation.Message.PositionEmpty)
        let emailValidation = Validation.validEmail(emailTextField.text)
        let countryCode = Validation.validString(countryTextField.text, emptyMessage: "Country Code Empty")
        let phoneValidation = Validation.validPhone(phoneTextField.text?.intString())
        
        let validations = [firstValidation, lastValidation, restaurantValidation, positionValidation, emailValidation, countryCode, phoneValidation]
        for validation in validations {
            if !validation.valid || validation == validations.last {
                completion(validation)
                return
            }
        }
    }
}

// MARK: UITextFieldDelegate

extension OnboardingIndustryViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == countryTextField, countryTextField.text?.isEmpty == true  {
            countryCode = countryCodes[0]
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneTextField {
            return range.location < countryCode?.charLimit ?? 10
        } else {
            return true
        }
    }
}

extension OnboardingIndustryViewController: CountryCodePickerDelegate {
    func selectedCountryCode(_ code: CountryCode) {
        countryCode = code
    }
}

// MARK: Class Func

extension OnboardingIndustryViewController {
    class func identifier()-> String {
        return "OnboardingIndustryViewControllerIdentifier"
    }
}
