//
//  ReservationsViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/12/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import XLPagerTabStrip
import EventKit

class ReservationsViewController: UIViewController {
    
    // MARK: Variables
    
    var reservations: [Reservation]?
    var state: State = .loading {
        didSet {
            switch state {
            case .loading:
                activityIndicator.startAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    self.reservationsCollectionView.alpha = 0.0
                })
            case .success(let reservations):
                activityIndicator.stopAnimating()
                self.reservations = reservations
                reservationsCollectionView.reloadData()
                UIView.animate(withDuration: 0.2, animations: {
                    self.reservationsCollectionView.alpha = 1.0
                })
                emptyLabel.isHidden = !reservations.isEmpty
            case .error:
                activityIndicator.stopAnimating()
            }
        }
    }
    
    enum State {
        case loading, success([Reservation]), error
    }
    
    // MARK: IBOutlet
    
    @IBOutlet weak var reservationsCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reservationsCollectionView.register(UINib.init(nibName: "ReservationCell", bundle: nil), forCellWithReuseIdentifier: "ReservationCellIdentifier")
        reservationsCollectionView.register(UINib.init(nibName: "SquareReservationCell", bundle: nil), forCellWithReuseIdentifier: "SquareReservationCellIdentifier")
    }
    
    // MARK: Function
    
    func pushReservationInformation(_ reservation: Reservation) {
        guard let date = reservation.date.convertApiDateStringToDate() else { assertionFailure()
            return
        }
        let model = ReservationDetailsModel.init(restaurant: reservation.restaurant, partySize: reservation.partySize, date: date, time: reservation.time ?? reservation.prefTime?.timeString())
        navigationController?.pushReservationDetails(model)
    }
    
    func pushBookAgain(_ reservation: Reservation) {
        let model = ReservationRequestModel.init(reservation.restaurant)
        navigationController?.pushReservationRequest(model)
    }
}

extension ReservationsViewController: GrantCalendarViewControllerDelegate {
    func accessGranted(_ granted: Bool) {
        Printer.print("Access granted to add reservation")
    }
}
