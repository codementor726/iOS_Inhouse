//
//  OnboardingTransitions.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/17/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit

// MARK: Constant

private let style: UIModalTransitionStyle = .crossDissolve

// MARK: Onboarding Transitions

extension UIViewController {
    public func transitionToOnboardingSubmited() {
        let submitted = storyboard?.instantiateViewController(withIdentifier: OnboardingSubmittedViewController.identifier())
        submitted?.modalTransitionStyle = style
        present(submitted!, animated: true, completion: nil)
    }
    
    public func transitionToOnboardingStart() {
        let onboardingStart = storyboard?.instantiateViewController(withIdentifier: OnboardingStartViewController.identifier()) as! OnboardingStartViewController
        onboardingStart.modalTransitionStyle = style
        present(onboardingStart, animated: true, completion: nil)
    }
    
    func transitionToOnboardingIndustry(info: RequiredIndustrySignup?) {
        let onboardingIndustry = storyboard?.instantiateViewController(withIdentifier: OnboardingIndustryViewController.identifier()) as! OnboardingIndustryViewController
        onboardingIndustry.modalTransitionStyle = style
        onboardingIndustry.info = info
        present(onboardingIndustry, animated: true, completion: nil)
    }
    
    func transitionToOnboardingSecond(_ info: RequiredIndustrySignup) {
        let onboardingSecond = storyboard?.instantiateViewController(withIdentifier: OnboardingIndustrySecondViewController.identifier()) as! OnboardingIndustrySecondViewController
        onboardingSecond.requiredInfo = info
        onboardingSecond.modalTransitionStyle = style
        present(onboardingSecond, animated: true, completion: nil)
    }
    
    public func transitionToOnboardingCode(_ phone: String) {
        let onboardingCode = storyboard?.instantiateViewController(withIdentifier: OnboardingCodeViewController.identifier()) as! OnboardingCodeViewController
        onboardingCode.phone = phone
        onboardingCode.modalTransitionStyle = style
        present(onboardingCode, animated: true, completion: nil)
    }
    
    public func transitionToOnboardingPhone() {
        let onboardingPhone = storyboard?.instantiateViewController(withIdentifier: OnboardingPhoneViewController.identifier()) as! OnboardingPhoneViewController
        onboardingPhone.modalTransitionStyle = style
        present(onboardingPhone, animated: true, completion: nil)
    }
    
    public func transitionToTutorial() {
        let tutorial = UIStoryboard.init(name: "Tutorial", bundle: nil).instantiateInitialViewController()!
        tutorial.modalTransitionStyle = style
        present(tutorial, animated: true, completion: nil)

    }
    
    public func transitionToGrantLocation() {
        let location = UIStoryboard.init(name: "Grants", bundle: nil).instantiateViewController(withIdentifier: GrantLocationViewController.identifier()) as! GrantLocationViewController
        location.modalTransitionStyle = style
        present(location, animated: true, completion: nil)
    }
    
    public func transitionToLoggedIn() {
        let main = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()!
        main.modalTransitionStyle = style
        present(main, animated: true, completion: nil)
    }
}
