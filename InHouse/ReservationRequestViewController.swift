//
//  ReservationRequestViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/19/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit

class ReservationRequestViewController: UIViewController {
    
    // MARK: Public Variables
    
    var model: ReservationRequestModel?
    var state: State = .initial {
        didSet {
            switch state {
            case .initial:
                break
            case .loading:
                handleLoading()
            case .success(let reservation):
                handleSuccess(reservation)
            case .error(let model, let error):
                handleError(model, error: error)
            }
        }
    }
    enum State {
        case initial, loading, success(Reservation), error(model: ReservationRequestModel, message: String?)
    }
    
    // MARK: IBOutlet/UI
    
    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var reservationDateTextField: UITextField!
    @IBOutlet weak var preferredTextField: UITextField!
    @IBOutlet weak var minimumTimeLabel: UILabel!
    @IBOutlet weak var maximumTimeLabel: UILabel!
    @IBOutlet weak var timeSlider: TwoSidedTimeSlider!
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var timeFrameView: UIView!
    @IBOutlet weak var requestButton: LoadingButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var commentsTextView: UITextView!
    lazy private var preferredTimePicker = UIDatePicker()
    
    // MARK: - "Init"
    
    static func makeReservationRequestVC(model: ReservationRequestModel) -> ReservationRequestViewController {
        let reservationVC = UIStoryboard(name: "Request", bundle: nil).instantiateInitialViewController() as! ReservationRequestViewController
        reservationVC.model = model
        return reservationVC
    }
    
    // MARK: View Lifeycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredTimePicker.datePickerMode = .time
        preferredTimePicker.minuteInterval = 15
        preferredTimePicker.addTarget(self, action: #selector(self.datePickerChanged(_:)), for: .valueChanged)
        preferredTextField.inputView = preferredTimePicker
        selectButton.reverseButtonImage()
        timeSlider.delegate = self
        calendarView.delegate = self
        calendarView.jtCalendarView.cellSize = (UIScreen.main.bounds.width - 40)/7
        if let model = model {
            configure(model)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MixpanelHelper.screenView("ReservationRequest")
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 86/255.0, green: 100/255.0, blue: 113/255.0, alpha: 1.0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = Colors.DarkBlue
        super.viewWillDisappear(animated)
    }
    
    // MARK: Reservation
    
    func requestReservation(_ model: ReservationRequestModel, pref: Date, min: Date, max: Date) {
        InHouseAPI.shared.requestReservation(restaurantId: model.restaurant.id, date: model.date.apiString(), prefTime: pref, minTime: min, maxTime: max, partySize: model.partySize, commments: commentsTextView.text) { (success, reservation, error) in
            if let reservation = reservation {
                self.state = .success(reservation)
            } else {
                self.state = .error(model: model, message: error)
            }
        }
    }
    
    // MARK: Configure
    
    public func configure(_ model: ReservationRequestModel) {
        restaurantLabel.text = model.restaurant.name
        addressLabel.text = model.restaurant.crossStreets
        reservationDateTextField.text = model.date.stringWithFormat("EEEE, MMMM d")
        partyLabel.text = "\(model.partySize)"
    }
    
    // MARK: Date Changed
    
    @objc func datePickerChanged(_ picker: UIDatePicker) {
        if picker == preferredTimePicker {
            timeSlider.preferredTime = picker.date
        }
    }
    
    // MARK: IBAction
    
    @IBAction func tapRequest(_ sender: UIButton) {
        MixpanelHelper.buttonTap("RequestReservation")
        state = .loading
    }
    
    @IBAction func tapSelectTime(_ sender: UIButton) {
        preferredTextField.becomeFirstResponder()
    }
    
    @IBAction func tapDate(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.calendarView.alpha = 1.0
        })
    }
    
    @IBAction func tapPlusParty(_ button: UIButton) {
        guard let model = model else { return }
        
        if model.partySize >= 10 {
            partyLabel.shake()
            return
        }
        self.model?.partySize = model.partySize + 1
        partyLabel.text = "\(model.partySize + 1)"
    }
    
    @IBAction func tapMinusParty(_ buttton: UIButton) {
        guard let model = model else { return }
        
        if model.partySize == 1 {
            partyLabel.shake()
            return
        }
        self.model?.partySize = model.partySize - 1
        partyLabel.text = "\(model.partySize - 1)"
    }
    
    @IBAction func tapBackground(_ sender: UITapGestureRecognizer) {
        if calendarView.alpha == 1.0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.calendarView.alpha = 0.0
            })
        }
    }
    
    @IBAction func tapCancel(_ sender: UIBarButtonItem) {
        navigationController?.navigationBar.barTintColor = Colors.DarkBlue
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: State Handling

extension ReservationRequestViewController {
    func handleLoading() {
        guard let pref = model?.prefTime, let min = model?.minTime, let max = model?.maxTime else {
            showMessage(nil, title: "Select Preferred Time")
            return
        }
        if let model = model {
            requestButton.showLoading()
            requestReservation(model, pref: pref, min: min, max: max)
        }
    }
    
    func handleSuccess(_ reservation: Reservation) {
        requestButton.hideLoading()
        guard let date = reservation.date.convertApiDateString("EEEE, MMMM d"), let pref = preferredTextField.text else { assertionFailure()
            return
        }
        let popupModel = ReservationSuccessViewModel.init(.request, restaurant: reservation.restaurantName, partySize: reservation.partySize, date: date, time: pref)
        navigationController?.showSuccessfulReservationPopup(popupModel, delegate: self)
    }
    
    func handleError(_ model: ReservationRequestModel, error: String?) {
        requestButton.hideLoading()
        guard let dateString = model.date.stringWithFormat("EEEE, MMMM d"), let pref = preferredTextField.text else { assertionFailure()
            return
        }
        let model = ReservationErrorPopupViewModel.init(restaurant: model.restaurant.name, partySize: model.partySize, dateString: dateString, time: pref, error: error)
        navigationController?.showErrorReservationPopup(model, delegate: self)
    }
}

// MARK: TwoSidedTimeSliderDelegate

extension ReservationRequestViewController: TwoSidedTimeSliderDelegate {
    func preferredTimeChanged(_ date: Date) {
        guard let model = model else { return }
        
        let prefTime = Date.init(year: model.date.year, month: model.date.month, day: model.date.day, hour: date.hour, minute: date.minute, second: 0)
        selectButton.setTitle(date.timeString(), for: .normal)
        preferredTextField.text = date.timeString()
        timeFrameView.isHidden = false
        self.model?.prefTime = prefTime
    }
    
    func minimumTimeChanged(_ date: Date) {
        guard let model = model else { return }
        
        let minTime = Date.init(year: model.date.year, month: model.date.month, day: model.date.day, hour: date.hour, minute: date.minute, second: 0)
        minimumTimeLabel.text = date.timeString()
        self.model?.minTime = minTime
    }
    
    func maximumTimeChanged(_ date: Date) {
        guard let model = model else { return }
        
        let maxTime = Date.init(year: model.date.year, month: model.date.month, day: model.date.day, hour: date.hour, minute: date.minute, second: 0)
        maximumTimeLabel.text = date.timeString()
        self.model?.maxTime = maxTime
    }
}

// MARK: ReservationSuccessPopupViewDelegate

extension ReservationRequestViewController: ReservationSuccessPopupViewDelegate {
    func popupFinished() {
        navigationController?.navigationBar.barTintColor = Colors.DarkBlue
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: CalendarViewDelegate

extension ReservationRequestViewController: CalendarViewDelegate {
    func selectedDateChanged(_ date: Date) {
        model?.date = date
        reservationDateTextField.text = date.stringWithFormat("EEEE, MMMM d")
        UIView.animate(withDuration: 0.3, animations: {
            self.calendarView.alpha = 0.0
        })
    }
}

// MARK: ReservationErrorPopupViewDelegate

extension ReservationRequestViewController: ReservationErrorPopupViewDelegate {
    func retryReservation() {
        state = .loading
    }
}

// MARK: UITextfieldDelegate

extension ReservationRequestViewController: UITextViewDelegate {
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

// MARK: Class Func

extension ReservationRequestViewController {
    class func identifier() -> String {
        return "ReservationRequestViewControllerIdentifier"
    }
}
