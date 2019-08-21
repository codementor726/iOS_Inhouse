//
//  BookByAlphabeticalViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/13/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit

fileprivate let calendarHeight: CGFloat = 370
fileprivate let partyHeight: CGFloat = 50

class BookByAlphabeticalViewController: BookByViewController {
    
    // MARK: Variables
    
    var currentQuery: String? {
        didSet {
            state = .initialLoading
        }
    }
    var selectionState: SelectionState = .none {
        didSet {
            switch selectionState {
            case .none:
                dismissSelectionViews()
            case .date:
                showBlurViews()
                showDateView()
                partyCollectionViewHeight.constant = 0
            case .party:
                showBlurViews()
                showPartyView()
                calendarContainerView.alpha = 0.0
            }
        }
    }
    enum SelectionState {
        case none, date, party
    }
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var calendarContainerView: UIView!
    @IBOutlet weak var calendarView: CalendarView!
    
    // MARK: Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "INHOUSE"
        dateButton.setTitle("Tomorrow", for: .normal)
        calendarView.jtCalendarView.cellSize = (UIScreen.main.bounds.width - 40)/7
        calendarView.delegate = self
        searchTextField.inputAccessoryView = UIView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MixpanelHelper.screenView("BookByAlphabetical")
        selectionState = .none
    }
    
    // MARK: Load
    
    override func loadInventory(initial: Bool) {
        let loadDate = date.apiString()
        let loadParty = partySize
        let loadQ = currentQuery
        InHouseAPI.shared.getAvailability(initial: initial, date: date.apiString(), partySize: partySize, query: currentQuery, neighborhoodIds: nil) { [weak self] (success, inventory, error) in
            guard loadDate == self?.date.apiString(), loadParty == self?.partySize, loadQ == self?.currentQuery else { return }
            if success {
                if initial {
                    self?.state = .initialLoaded(inventory)
                } else {
                    self?.state = .nextPageLoaded(inventory)
                }
            } else {
                self?.state = .error
            }
        }
    }
    
    // MARK: View Hide/Unhide
    
    override func dismissSelectionViews() {
        super.dismissSelectionViews() // dismisses party view
        UIView.animate(withDuration: 0.3, animations: {
            self.calendarContainerView.alpha = 0
        })
    }
    
    private func showDateView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.calendarContainerView.alpha = 1.0
        })
    }
    
    // MARK: IBAction/Touch
    
    @IBAction func tapDateButton(_ sender: UIButton) {
        if selectionState != .date {
            selectionState = .date
        } else {
            selectionState = .none
        }
    }
    
    @IBAction func tapPartyButton(_ sender: UIButton) {
        if selectionState != .party {
            selectionState = .party
        } else {
            selectionState = .none
        }
    }
    
    @IBAction func tapSearchCancel(_ sender: UIButton) {
        searchTextField.resignFirstResponder()
        searchTextField.text = nil
        if currentQuery != nil {
            currentQuery = nil
        }
    }
    
    @IBAction override func tapBackground(_ sender: UITapGestureRecognizer) {
        selectionState = .none
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectionState = .none
    }
    
    // MARK: PartyCollectionViewDelegate
    
    override func partySizeChanged(_ size: String) {
        if let int = size.int() {
            partySize = int
            UIView.animate(withDuration: 0.3) {
                self.partyCollectionViewHeight.constant = 0
                self.view.layoutIfNeeded()
            }
        }
        partySizeButton.setTitle("Party of \(size)", for: .normal)
        state = .initialLoading
        selectionState = .none
    }
}

// MARK: CalendarViewDelegate

extension BookByAlphabeticalViewController: CalendarViewDelegate {
    func selectedDateChanged(_ date: Date) {
        self.date = date
        switch date {
        case Date.tomorrow():
            dateButton.setTitle("Tomorrow", for: .normal)
        default:
            dateButton.setTitle(date.stringWithFormat("EEEE, MMM d"), for: .normal)
        }
        state = .initialLoading
        selectionState = .none
    }
}

// MARK: UITextFieldDelegate

extension BookByAlphabeticalViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && string == "" {
            if currentQuery != nil {
                currentQuery = nil
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.isEmpty == false {
            currentQuery = textField.text
            textField.resignFirstResponder()
        }
        return true
    }
}

// MARK: Class Func

extension BookByAlphabeticalViewController {
    class func identifier()-> String {
        return "BookByAlphabeticalViewControllerIdentifier"
    }
}
