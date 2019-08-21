//
//  BookByViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/8/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit

class BookByViewController: UIViewController, PartyCollectionViewDelegate {
    
    // MARK: Variables
    
    var availableInventory: [AvailableInventoryItem] = [AvailableInventoryItem]() {
        didSet {
            availableCollectionView.reloadData()
        }
    }
    var partySize: Int = 2
    var date: Date = Date.tomorrow()
    
    // MARK: State
    
    enum State {
        case initialLoading, initialLoaded([AvailableInventoryItem]?), nextPageLoaded([AvailableInventoryItem]?), error
    }

    var state: State = .initialLoading {
        didSet {
            switch state {
            case .initialLoading:
                availableInventory.removeAll()
                activityIndicator.startAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    self.availableCollectionView.alpha = 0.0
                })
                loadInventory(initial: true)
            case .initialLoaded(let items):
                activityIndicator.stopAnimating()
                if let items = items {
                    availableInventory = items
                }
                UIView.animate(withDuration: 0.2, animations: {
                    self.availableCollectionView.alpha = 1.0
                })
            case .nextPageLoaded(let items):
                availableCollectionView.finishInfiniteScroll()
                if let items = items {
                    availableInventory.append(contentsOf: items)
                }
            case .error:
                activityIndicator.stopAnimating()
                availableCollectionView.finishInfiniteScroll()
                showMessage("Error Loading Inventory", title: "Error")
            }
        }
    }
    
    // MARK: IBOutlet
    
    @IBOutlet weak var partySizeButton: UIButton!
    @IBOutlet weak var availableCollectionView: UICollectionView!
    @IBOutlet weak var partyCollectionView: PartyCollectionView?
    @IBOutlet weak var partyCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mainBlurView: UIVisualEffectView!
    var blurView: UIVisualEffectView?
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        availableCollectionView.register(UINib.init(nibName: "AvailableReservationCell", bundle: nil), forCellWithReuseIdentifier: AvailableReservationCell.identifier())
        
        let tapBackground = UITapGestureRecognizer.init(target: self, action: #selector(self.tapBackground(_:)))
        tapBackground.cancelsTouchesInView = false
        availableCollectionView.addGestureRecognizer(tapBackground)
        partyCollectionViewHeight?.constant = 0
        partyCollectionView?.partySizeDelegate = self
        
        setupInfiniteScroll()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let bottomBlurEffect = UIVisualEffectView(effect: blurEffect)
        bottomBlurEffect.frame = tabBarController!.tabBar.bounds
        bottomBlurEffect.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView = bottomBlurEffect
        blurView?.alpha = 0.0
        tabBarController?.tabBar.addSubview(bottomBlurEffect)
        
        state = .initialLoading
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissSelectionViews()
    }
    
    // MARK: Infinite Scroll
    
    fileprivate func setupInfiniteScroll() {
        availableCollectionView.addInfiniteScroll { [weak self] (collectionView) -> Void in
            self?.loadInventory(initial: false)
        }
    }
    
    // MARK: Load
    
    func loadInventory(initial: Bool) {
        assertionFailure("Override")
    }
    
    // MARK: IBAction
    
    @IBAction func tapCancel(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func tapBackground(_ sender: UITapGestureRecognizer) {
        dismissSelectionViews()
    }
    
    // MARK: PartyCollectionViewDelegate
    
    func partySizeChanged(_ size: String) {
        if let int = size.int() {
            partySize = int
            UIView.animate(withDuration: 0.3) {
                self.partyCollectionViewHeight.constant = 0
                self.view.layoutIfNeeded()
            }
        }
        partySizeButton.setTitle("Party of \(size)", for: .normal)
        state = .initialLoading
    }
}

// MARK: UICollectionViewDataSource

extension BookByViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return availableInventory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AvailableReservationCell.identifier(), for: indexPath) as! AvailableReservationCell
        let item = availableInventory[indexPath.row]
        cell.model = AvailableReservationModel.init(restaurant: item.restaurant.name, neighborhood: item.restaurant.neighborhood, address: item.restaurant.address, timeslots: item.timeslots)
        cell.delegate = self
        return cell
    }
}

// MARK: UICollectionViewDelegate

extension BookByViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        MixpanelHelper.buttonTap("RestaurantAvailabilityCell")
        let item = availableInventory[indexPath.row]
        let model = RestaurantBookingModel.init(restaurant: item.restaurant, partySize: partySize, date: date, timeslots: item.timeslots)
        dismissSelectionViews()
        navigationController?.pushRestaurantBooking(model)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: UIScreen.main.bounds.width - 36, height: AvailableReservationCell.height())
    }
}

// MARK: UIScrollViewDelegate

extension BookByViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissSelectionViews()
    }
}

// MARK: Animate

extension BookByViewController {
    @objc func dismissSelectionViews() {
        // Override to dismiss other views, calendar, neighborhood, etc.
        dismissPartySize()
        dismissBlurViews()
    }
    
    func showPartyView() {
        togglePartyView(hide: false)
    }
    
    func dismissPartySize() {
        togglePartyView(hide: true)
    }
    
    private func togglePartyView(hide: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.partyCollectionViewHeight?.constant = hide ? 0 : 50
            self.view.layoutIfNeeded()
        }
    }
    
    func showBlurViews() {
        toggleBlurViews(hide: false)
    }
    
    func dismissBlurViews() {
        toggleBlurViews(hide: true)
    }
    
    private func toggleBlurViews(hide: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.blurView?.alpha = hide ? 0.0 : 1.0
            self.mainBlurView.alpha = hide ? 0.0 : 1.0
        }
    }
}

// MARK: AvailableReservactionCellDelegate

extension BookByViewController: AvailableReservationCellDelegate {
    func requestReservation(_ cell: AvailableReservationCell) {
        if let index = availableCollectionView.indexPath(for: cell)?.row {
            let item = availableInventory[index]
            let model = ReservationRequestModel.init(item.restaurant, date: date, partySize: partySize)
            navigationController?.pushReservationRequest(model)
        }
    }
    
    func bookReservationAtTime(_ cell: AvailableReservationCell, timeslot: Timeslot) {
        if let index = availableCollectionView.indexPath(for: cell)?.row {
            let item = availableInventory[index]
            let model = ReservationBookingModel.init(item.restaurant, date: date, timeslot: timeslot, partySize: partySize)
            navigationController?.pushReservationBooking(model)
        }
    }
}
