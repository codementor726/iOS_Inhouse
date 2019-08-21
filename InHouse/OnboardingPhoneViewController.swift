//
//  OnboardingPhoneViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/17/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit
import PinCodeTextField

class OnboardingPhoneViewController: UIViewController {
    
    // MARK: IBOutlet
    
    @IBOutlet weak var phoneTextField: PinCodeTextField!
    @IBOutlet weak var nextButton: LoadingButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var countryTextField: UITextField!
    lazy var countryCodePicker: CountryCodePicker = CountryCodePicker()
    var countryCode: CountryCode = countryCodes[0] {
        didSet {
            countryTextField.text = countryCode.description
            phoneTextField.characterLimit = countryCode.charLimit
            phoneTextField.text = "" // used to trigger update of it's views (underlines)
        }
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneTextField.font = Fonts.Colfax.Medium(16)
        phoneTextField.keyboardType = .phonePad
        phoneTextField.delegate = self
        
        let tapView = UITapGestureRecognizer.init(target: self, action: #selector(didTapView(_:)))
        backgroundView.addGestureRecognizer(tapView)
        
        countryTextField.delegate = self
        countryTextField.inputView = countryCodePicker
        countryCodePicker.delegate = countryCodePicker
        countryCodePicker.countryDelegate = self
        
        countryCode = countryCodes[0]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        MixpanelHelper.screenView("OnboardingPhone")
        phoneTextField.becomeFirstResponder()
    }
    
    // MARK: Sign Up
    
    func startSignUp() {
        validSignUp() { [unowned self] validation in
            switch validation.valid {
            case true:
                self.submitSignUp()
            case false:
                self.showMessage(nil, title: validation.message)
            }
        }
    }
    
    func submitSignUp() {
        guard let phone = phoneTextField.text else { return }
        
        nextButton.showLoading()
        let fullNumber = "\(countryCode.rawNumber)\(phone)"
        InHouseAPI.shared.phoneNumberSignUp(fullNumber) { (success, item, error) in
            self.nextButton.hideLoading()
            if success {
                self.transitionToOnboardingCode(fullNumber)
            } else {
                self.showMessage(error ?? "Error Validating Phone", title: "Error")
            }
        }
    }
    
    // MARK: IBAction
    
    @IBAction func tapNext(_ sender: UIButton) {
        MixpanelHelper.buttonTap("PhoneNumberNext")
        startSignUp()
    }
    
    @IBAction func tapInterestedInJoining(_ sender: UIButton) {
        emailHelloInHouse(subject: "Membership", body: "Hi, I'm interested in learning more about becoming a member.")
    }
    
    @IBAction func tapCancel(_ sender: UIButton) {
        transitionToOnboardingStart()
    }
    
    @IBAction func didTapView(_ sender: UITapGestureRecognizer) {
        if phoneTextField.isFirstResponder {
            phoneTextField.resignFirstResponder()
        }
    }
}

// MARK: PinCodeTextFieldDelegate

extension OnboardingPhoneViewController: PinCodeTextFieldDelegate {
    @nonobjc func textFieldShouldEndEditing(_ textField: PinCodeTextField)-> Bool {
        if textField.text?.count == textField.characterLimit, nextButton.isUserInteractionEnabled {
            startSignUp()
        }
        return true
    }
}

// MARK: UIPickerView/UITextfield

extension OnboardingPhoneViewController: UITextFieldDelegate, CountryCodePickerDelegate {
    func selectedCountryCode(_ code: CountryCode) {
        countryCode = code
    }
}

// MARK: Validation 

extension OnboardingPhoneViewController {
    func validSignUp(completion: @escaping (ValidationReturn)-> Void) {
        let validation = Validation.validPhone(phoneTextField.text)
        completion(validation)
    }
}

// MARK: Class Func

extension OnboardingPhoneViewController {
    class func identifier()-> String {
        return "OnboardingPhoneViewControllerIdentifier"
    }
}
