//
//  OnboardingCodeViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/14/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit
import PinCodeTextField

class OnboardingCodeViewController: UIViewController {
    
    // MARK: Variables
    
    var phone: String?

    // MARK: IBOutlet
    
    @IBOutlet weak var enterCodeLabel: UILabel!
    @IBOutlet weak var invalidCodeLabel: UILabel!
    @IBOutlet weak var codeTextField: PinCodeTextField!
    @IBOutlet weak var nextButton: LoadingButton!
    @IBOutlet weak var backgroundView: UIView!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codeTextField.font = Fonts.Colfax.Medium(16)
        codeTextField.keyboardType = .phonePad
        codeTextField.delegate = self
        
        let tapView = UITapGestureRecognizer.init(target: self, action: #selector(didTapView(_:)))
        backgroundView.addGestureRecognizer(tapView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MixpanelHelper.screenView("OnboardingCode")
        codeTextField.becomeFirstResponder()
    }
    
    // MARK: Sign In
    
    func startSignIn() {
        validSignUp() { validation in
            switch validation.valid {
            case true:
                guard let code = self.codeTextField.text, let phone = self.phone else { return }
                self.submitSignIn(code, phone: phone)
            case false:
                self.showMessage(validation.message, title: "Error")
            }
        }
    }
    
    func submitSignIn(_ code: String, phone: String) {
        self.nextButton.showLoading()
        InHouseAPI.shared.codeSignIn(code, phone: phone) { (success, user, error)-> Void in
            self.nextButton.hideLoading()
            if success, let user = user {
                CurrentUser().set(user)
                MixpanelHelper.setUser(name: CurrentUser().name(), email: user.email)
                
                self.validCode()
                self.transitionToTutorial()
            } else {
                self.invalidCode()
            }
        }
    }
    
    func resendCode(_ phone: String) {
        InHouseAPI.shared.phoneNumberSignUp(phone) { (success, item, error) in
            if !success {
                self.showMessage("Error Resending Code", title: "Error")
            }
        }
    }
    
    // MARK: IBAction
    
    @IBAction func tapNext(_ sender: UIButton) {
        MixpanelHelper.buttonTap("CodeSignInNext")
        startSignIn()
    }
    
    @IBAction func tapResend(_ sender: UIButton) {
        MixpanelHelper.buttonTap("ResendCode")
        if let phone = phone {
            resendCode(phone)
        }
    }
    
    @IBAction func tapHelp(_ sender: UIButton) {
        needHelpEmail()
    }
    
    @IBAction func tapCancel(_ sender: UIButton) {
        transitionToOnboardingStart()
    }
    
    @IBAction func didTapView(_ sender: UITapGestureRecognizer) {
        if codeTextField.isFirstResponder {
            codeTextField.resignFirstResponder()
        }
    }
}

// MARK: Validation

extension OnboardingCodeViewController {
    func validSignUp(completion: @escaping (ValidationReturn)-> Void) {
        let codeValidation = Validation.validCode(codeTextField.text?.int())
        completion(codeValidation)
    }
    
    fileprivate func invalidCode() {
        enterCodeLabel.shake()
        enterCodeLabel.alpha = 1.0
        enterCodeLabel.textColor = Colors.OffRed
        invalidCodeLabel.isHidden = false
    }
    
    fileprivate func validCode() {
        enterCodeLabel.alpha = 0.5
        enterCodeLabel.textColor = Colors.OffWhite
        invalidCodeLabel.isHidden = true
    }
}

// MARK: Class Func

extension OnboardingCodeViewController {
    class func identifier()-> String {
        return "OnboardingCodeViewControllerIdentifier"
    }
}

// MARK: PinCodeTextFieldDelegate

extension OnboardingCodeViewController: PinCodeTextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: PinCodeTextField) -> Bool {
        if textField.text?.count == textField.characterLimit, nextButton.isUserInteractionEnabled {
            startSignIn()
        }
        return true
    }
}
