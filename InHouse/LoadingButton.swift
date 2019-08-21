//
//  LoadingButton.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/14/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit

class LoadingButton: UIButton {
    
    // MARK: Variables
    
    private var originalButtonText: String?
    private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Public Func
    
    public func showLoading() {
        originalButtonText = self.titleLabel?.text
        self.setTitle("", for: UIControlState.normal)
        
        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }
        showSpinning()
        isUserInteractionEnabled = false
    }
    
    public func hideLoading() {
        self.setTitle(originalButtonText, for: UIControlState.normal)
        activityIndicator.stopAnimating()
        isUserInteractionEnabled = true
    }
    
    // MARK: Private Func
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .lightGray
        return activityIndicator
    }
    
    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }
    
    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        addConstraint(yCenterConstraint)
    }
}
