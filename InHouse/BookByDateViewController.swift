//
//  BookByDateViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/13/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit

class BookByDateViewController: BookByViewController {
    
    // MARK: State
    
    var selectionState: SelectionState = .none {
        didSet {
            switch selectionState {
            case .none:
                dismissSelectionViews()
            case .party:
                showBlurViews()
                showPartyView()
            }
        }
    }
    enum SelectionState {
        case none, party
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = date.stringWithFormat("MMM d, yyyy")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MixpanelHelper.screenView("BookByDate")
    }
    
    // MARK: Load
    
    override func loadInventory(initial: Bool) {
        let loadParty = partySize
        InHouseAPI.shared.getAvailability(initial: initial, date: date.apiString(), partySize: partySize, query: nil, neighborhoodIds: nil) { [weak self] (success, inventory, error) in
            guard loadParty == self?.partySize else { return }
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
    
    // MARK: IBAction
    
    @IBAction func tapPartyButton(_ sender: UIButton) {
        if selectionState != .party {
            selectionState = .party
        } else {
            selectionState = .none
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
