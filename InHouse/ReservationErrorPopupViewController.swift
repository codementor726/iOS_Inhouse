//
//  ReservationErrorPopupViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/28/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit

struct ReservationErrorPopupViewModel {
    var restaurant: String
    var partySize: Int
    var dateString: String
    var time: String
    var error: String?
    
    init(restaurant: String, partySize: Int, dateString: String, time: String, error: String?) {
        self.restaurant = restaurant
        self.partySize = partySize
        self.dateString = dateString
        self.time = time
        self.error = error
    }
}

protocol ReservationErrorPopupViewDelegate: class {
    func retryReservation()
}

class ReservationErrorPopupViewController: UIViewController {
    
    // MARK: Variable
    
    var model: ReservationErrorPopupViewModel?
    weak var delegate: ReservationErrorPopupViewDelegate?
    
    // MARK: IBOutlet
    
    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var errorDetailsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let model = model {
            configure(model)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MixpanelHelper.screenView("ReservationErrorPopup")
    }
    
    // MARK: Configure
    
    public func configure(_ model: ReservationErrorPopupViewModel) {
        restaurantLabel.text = model.restaurant
        if let error = model.error, error.count < 100 {
            errorDetailsLabel.text = error
        }
        descriptionLabel.text = "Party of \(model.partySize) on \(model.dateString) at \(model.time)"
    }
    
    // MARK: IBAction
    
    @IBAction func tapTryAgain(_ sender: UIButton) {
        MixpanelHelper.buttonTap("ReservationErrorTryAgain")
        dismiss(animated: true, completion: {
            self.delegate?.retryReservation()
        })
    }
    
    @IBAction func tapCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: Class Func

extension ReservationErrorPopupViewController {
    class func identifier()-> String {
        return "ReservationErrorPopupViewControllerIdentifier"
    }
}
