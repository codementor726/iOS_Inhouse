//
//  BookByInstantViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 2/26/18.
//  Copyright © 2018 Kevin Johnson. All rights reserved.
//

import UIKit

class BookByInstantViewController: BookByViewController {
    
    // MARK: - Variables
    
    var selectionState: SelectionState = .none {
        didSet {
            switch selectionState {
            case .none:
                dismissSelectionViews()
            case .date:
                showBlurViews()
                showDateView()
            }
        }
    }
    enum SelectionState {
        case none, date
    }
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var calendarContainerView: UIView!
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var emptyView: InstantReservationEmptyView!
    @IBOutlet weak var emptyViewTopConstraint: NSLayoutConstraint!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        guard currentCity.code == 1 else { // Only supported in NYC Currently
            emptyViewTopConstraint.constant = -50.0
            emptyView.alpha = 1.0
            return
        }
        
        super.viewDidLoad()
        dateButton.setTitle("Tomorrow", for: .normal)
        calendarView.jtCalendarView.cellSize = (UIScreen.main.bounds.width - 40)/7
        calendarView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MixpanelHelper.screenView("BookInstant")
    }
    
    // MARK: - Load Inventory
    
    override func loadInventory(initial: Bool) {
        if emptyView.alpha == 1.0 {
            emptyView.alpha = 0.0
        }
        InHouseAPI.shared.getInstantBookings(initial: initial, date: date.apiString()) { [weak self] (success, inventory, error) in
            if success {
                self?.state = (initial) ? .initialLoaded(inventory) : .nextPageLoaded(inventory)
                if initial, inventory?.isEmpty == true { // Perhaps override state in this VC - or override method called in state change on superclass
                    delayOnMainThread(0.5) {
                        self?.inventoryEmpty()
                    }
                }
            } else {
                self?.state = .error
            }
        }
    }
    
    private func inventoryEmpty() {
        UIView.animate(withDuration: 0.6, animations: {
            self.emptyView.alpha = 1.0
        })
    }
    
    // MARK: - View Hide/Unhide
    
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
    
    // MARK: - IBAction/Touch
    
    @IBAction func tapDateButton(_ sender: UIButton) {
        if selectionState != .date {
            selectionState = .date
        } else {
            selectionState = .none
        }
    }
    
    @IBAction func tapBrowseInventoryInstead(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        navigationController?.pushBookByAZ()
    }
}

// MARK: UICollectionViewDelegate

extension BookByInstantViewController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: UIScreen.main.bounds.width, height: 90.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "InstantHeaderView", for: indexPath)
    }
}

// MARK: - CalendarViewDelegate

extension BookByInstantViewController: CalendarViewDelegate {
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

// MARK: - Class Func

extension BookByInstantViewController {
    class func identifier()-> String {
        return "BookByInstantViewControllerIdentifier"
    }
}

// MARK: - InstantReservationEmptyView

class InstantReservationEmptyView: UIView {
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        switch currentCity.code {
        case 1:
            titleLabel.text = "Sorry!"
            subtitleLabel.text = "It looks like we don't have seats held on this date."
        case 2:
            titleLabel.text = "Coming Soon!"
            subtitleLabel.text = nil
        default:
            assertionFailure()
        }
    }
}
