//
//  ReservationSuccessPopupViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/28/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit
import EventKit

@objc protocol ReservationSuccessPopupViewDelegate: class {
    @objc optional func calendarAccessGranted()
    func popupFinished()
}

class ReservationSuccessPopupViewController: UIViewController {
    
    // MARK: Variables
    
    var model: ReservationSuccessViewModel?
    weak var delegate: ReservationSuccessPopupViewDelegate?
    
    // MARK: IBOutlet
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var oooLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let model = model {
            configure(model)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MixpanelHelper.screenView("ReservationSuccessPopup")
    }
    
    // MARK: Configure
    
    public func configure(_ model: ReservationSuccessViewModel) {
        restaurantLabel.text = model.restaurant
        descriptionLabel.text = "Party of \(model.partySize) on \(model.date) at \(model.time)"
        
        switch model.reservationType {
        case .request:
            configureForRequest()
        case .booking:
            configureForBooking()
        }
    }
    
    fileprivate func finished() {
        dismiss(animated: true, completion: {
            self.delegate?.popupFinished()
        })
    }
    
    // MARK: IBAction
    
    @IBAction func tapActionButton(_ sender: UIButton) {
        MixpanelHelper.buttonTap("ReservationSuccessPopupAction")
        if model?.reservationType == .booking, !calendarAccessDetermined() {
            presentGrantCalendar(self)
        } else {
            finished()
        }
    }
    
    @IBAction func tapCancel(_ sender: UIButton) {
        finished()
    }
}

// MARK: Configure

extension ReservationSuccessPopupViewController {
    func configureForRequest() {
        titleLabel.text = "Looking into this now!"
        subtitleLabel.text = "Thanks for requesting..."
        oooLabel.text = Date().oooMessage()
        actionButton.setTitle("OK", for: .normal)
    }
    
    func configureForBooking() {
        titleLabel.text = "All set!"
        subtitleLabel.text = "Thanks for booking..."
        if calendarAccessDetermined() && calendarAuthorized() {
            subtitleLabel.text?.append(" This has been added to your calendar")
        }
        
        switch calendarAccessDetermined() {
        case false:
            actionButton.setTitle("Add To Calendar", for: .normal)
        case true:
            actionButton.setTitle("OK", for: .normal)
        }
    }
}

// MARK: GrantCalendarViewControllerDelegate

extension ReservationSuccessPopupViewController: GrantCalendarViewControllerDelegate {
    func accessGranted(_ granted: Bool) {
        if granted {
            delegate?.calendarAccessGranted?()
        }
        finished()
    }
}

// MARK: Class Func

extension ReservationSuccessPopupViewController {
    class func identifier()-> String {
        return "ReservationSuccessPopupViewControllerIdentifier"
    }
}
