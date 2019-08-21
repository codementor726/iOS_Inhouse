//
//  ReservationBookingViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/14/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit
import UITextView_Placeholder

enum ReservationBookingViewControllerState {
    case initial, loading, success(Reservation), error(ReservationBookingModel)
}

class ReservationBookingViewController: UIViewController {
    
    // MARK: - Variables
    
    public var model: ReservationBookingModel!
    private var state: ReservationBookingViewControllerState = .initial {
        didSet {
            switch state {
            case .initial:
                break
            case .loading:
                handleLoading()
            case .success(let reservation):
                handleSuccess(reservation)
            case .error(let model):
                handleError(model)
            }
        }
    }
    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var partySize: UILabel!
    @IBOutlet weak var seatingLabel: UILabel!
    @IBOutlet weak var seatingLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var commentsTextView: UITextView!
    @IBOutlet weak var bookButton: LoadingButton!
    
    // MARK: - "Init"
    
    static func makeReservationBookingVC(model: ReservationBookingModel) -> ReservationBookingViewController {
        let reservationVC = UIStoryboard(name: "Booking", bundle: nil).instantiateInitialViewController() as! ReservationBookingViewController
        reservationVC.model = model
        return reservationVC
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(model)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MixpanelHelper.screenView("ReservationBooking")
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 86/255.0, green: 100/255.0, blue: 113/255.0, alpha: 1.0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = Colors.DarkBlue
        super.viewWillDisappear(animated)
    }
    
    // MARK: Configure
    
    public func configure(_ model: ReservationBookingModel) {
        restaurantLabel.text = model.restaurant.name
        addressLabel.text = model.restaurant.crossStreets
        dateLabel.text = model.date.stringWithFormat("EEEE, MMMM d")
        timeLabel.text = model.timeslot.time
        partySize.text = "\(model.partySize) Guests"
        if let tableType = model.timeslot.tableType {
            seatingLabel.text = tableType.uppercased()
        } else {
            seatingLabel.text = nil
            seatingLabelHeight.constant = 0
        }
    }
    
    // MARK: - Book Reservation
    
    private func bookReservation(_ model: ReservationBookingModel) {
        // Pass model? instead of 4 variables.
        InHouseAPI.shared.bookReservation(restaurantId: model.restaurant.id, date: model.date.apiString(), timeslotId: model.timeslot.id, partySize: model.partySize, comments: commentsTextView.text) { (success, reservation, error) in
            if let reservation = reservation {
                self.state = .success(reservation)
            } else {
                self.state = .error(model)
            }
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func tapBook(_ sender: UIButton) {
        MixpanelHelper.buttonTap("BookReservation")
        state = .loading
    }
    
    @IBAction func tapCancel(_ sender: UIBarButtonItem) {
        popToRoot()
    }
    
    // MARK: - Helper
    
    private func popToRoot() {
        navigationController?.navigationBar.barTintColor = Colors.DarkBlue
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - State Handling

extension ReservationBookingViewController {
    func handleLoading() {
        if let model = model {
            bookButton.showLoading()
            bookReservation(model)
        }
    }
    
    func handleSuccess(_ reservation: Reservation) {
        bookButton.hideLoading()
        guard let date = reservation.date.convertApiDateString("EEEE, MMMM d"), let time = reservation.time else { assertionFailure()
            return
        }

        let popupModel = ReservationSuccessViewModel.init(.booking, restaurant: reservation.restaurantName, partySize: reservation.partySize, date: date, time: time)
        navigationController?.showSuccessfulReservationPopup(popupModel, delegate: self)
        
        if calendarAccessDetermined() && calendarAuthorized(), let model = model {
            CalendarHelper.saveReservationBooking(model)
        }
    }
    
    func handleError(_ model: ReservationBookingModel) {
        bookButton.hideLoading()
        guard let dateString = model.date.stringWithFormat("EEEE, MMMM d") else { assertionFailure()
            return
        }
        let model = ReservationErrorPopupViewModel.init(restaurant: model.restaurant.name, partySize: model.partySize, dateString: dateString, time: model.timeslot.time, error: nil)
        navigationController?.showErrorReservationPopup(model, delegate: self)
    }
}

// MARK: - ReservationSuccessPopupViewDelegate

extension ReservationBookingViewController: ReservationSuccessPopupViewDelegate {
    func calendarAccessGranted() {
        if let model = model {
            CalendarHelper.saveReservationBooking(model)
        }
    }
    
    func popupFinished() {
        popToRoot()
    }
}

// MARK: - ReservationErrorPopupViewDelegate

extension ReservationBookingViewController: ReservationErrorPopupViewDelegate {
    func retryReservation() {
        state = .loading
    }
}

// MARK: - UITextfieldDelegate

extension ReservationBookingViewController: UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView == commentsTextView {
            commentsTextView.placeholderLabel.isHidden = false
        }
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView == commentsTextView {
            commentsTextView.placeholderLabel.isHidden = true
        }
        return true
    }
}

// MARK: - Class Func

extension ReservationBookingViewController {
    class func identifier() -> String {
        return "ReservationBookingViewControllerIdentifier"
    }
}
