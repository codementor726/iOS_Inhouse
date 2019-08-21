//
//  BookByMapViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/7/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit

class BookByMapViewController: BookByViewController {
    
    // MARK: Variables
    
    var selectedNeighborhoodIds: [Int] = [Int]() {
        didSet {
            guard isViewLoaded else { return }
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
    
    // MARK: IBOutlet
    
    @IBOutlet weak var neighborhoodCollectionView: NeighborhoodCollectionView!
    @IBOutlet weak var neighborhoodActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var calendarContainerView: UIView!
    @IBOutlet weak var calendarView: CalendarView!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        neighborhoodCollectionView.neighborhoodDelegate = self
        neighborhoodCollectionView.selectedIds = selectedNeighborhoodIds
        dateButton.setTitle("Tomorrow", for: .normal)
        calendarView.jtCalendarView.cellSize = (UIScreen.main.bounds.width - 40)/7
        calendarView.delegate = self
        loadNeighborhoods()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MixpanelHelper.screenView("BookBMap")
    }
    
    // MARK: Load Inventory
    
    override func loadInventory(initial: Bool) {
        let loadDate = date.apiString()
        let loadParty = partySize
        let loadIds = selectedNeighborhoodIds
        InHouseAPI.shared.getAvailability(initial: initial, date: date.apiString(), partySize: partySize, query: nil, neighborhoodIds: selectedNeighborhoodIds) { [weak self] (success, inventory, error) in
            guard loadDate == self?.date.apiString(), loadParty == self?.partySize, let loadedIds = self?.selectedNeighborhoodIds, loadIds == loadedIds else { return }
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
    
    // MARK: Load Neighborhoods
    
    func loadNeighborhoods() {
        neighborhoodActivityIndicator.startAnimating()
        InHouseAPI.shared.getNeighborhoods() { (success, neighborhoods, error) in
            self.neighborhoodActivityIndicator.stopAnimating()
            if success, let neighborhoods = neighborhoods {
                self.neighborhoodCollectionView.neighborhoods = neighborhoods
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

// MARK: NeighborhoodCollectionViewDelegate

extension BookByMapViewController: NeighborhoodCollectionViewDelegate {
    func neighborhoodIdsChanged(_ neighborhoodIds: [Int]) {
        selectedNeighborhoodIds = neighborhoodIds
    }
}

// MARK: CalendarViewDelegate

extension BookByMapViewController: CalendarViewDelegate {
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

// MARK: Class Func

extension BookByMapViewController {
    class func identifier()-> String {
        return "BookByMapViewControllerIdentifier"
    }
}
