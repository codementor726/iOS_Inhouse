//
//  GrantCalendarViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/3/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit
import EventKit

protocol GrantCalendarViewControllerDelegate: class {
    func accessGranted(_ granted: Bool)
}

class GrantCalendarViewController: UIViewController {
    
    // MARK: Variable
    
    weak var delegate: GrantCalendarViewControllerDelegate?
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(true, forKey: "CalendarAccessDetermined")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MixpanelHelper.screenView("GrantCalendar")
    }
    
    // MARK: Function
    
    private func determineAccess() {
        let status = EKEventStore.authorizationStatus(for: .event)
        if status == .notDetermined {
            requestAccess()
        } else if status == .authorized {
            dismiss(animated: true, completion: {
                self.delegate?.accessGranted(true)
            })
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func requestAccess() {
        EKEventStore().requestAccess(to: .event, completion: { [weak self] (granted: Bool, error: Error?) -> Void in
            self?.dismiss(animated: true, completion: {
                self?.delegate?.accessGranted(granted)
            })
        })
    }
    
    // MARK: IBAction
    
    @IBAction func tapGrantAccess(_ sender: UIButton) {
        MixpanelHelper.buttonTap("GrantCalendar")
        determineAccess()
    }
    
    @IBAction func tapDecline(_ sender: UIButton) {
        MixpanelHelper.buttonTap("DeclineCalendar")
        dismiss(animated: true, completion: nil)
    }
}

// MARK: Class Func

extension GrantCalendarViewController {
    class func identifier()-> String {
        return "GrantCalendarViewControllerIdentifier"
    }
}
