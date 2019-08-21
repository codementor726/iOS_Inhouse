//
//  ReservationCell.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/12/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit

protocol PastReservationCellDelegate: class {
    func presentBookAgain(_ cell: ReservationCell)
}

protocol UpcomingReservationCellDelegate: class {
    func presentReservationDetails(_ cell: ReservationCell)
    func addReservationToCalendar(_ cell: ReservationCell)
}

class ReservationCell: UICollectionViewCell {
    
    // MARK: Variables
    
    var model: ReservationViewModel? {
        didSet {
            if let model = model {
                configure(model)
            }
        }
    }
    weak var upcomingDelegate: UpcomingReservationCellDelegate?
    weak var pastDelegate: PastReservationCellDelegate?
    var inCalendar: Bool? {
        didSet {
            configureForBooked(inCalendar)
        }
    }
    
    // MARK: IBOutlet
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var reservationButton: LoadingButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    // MARK: Configure
    
    func configure(_ model: ReservationViewModel) {
        dateLabel.text = model.date.stringWithFormat("EEEE MMMM d, yyyy")
        restaurantLabel.text = model.restaurant
        addressLabel.text = model.address
        partyLabel.text = "Party of \(model.partySize)"
        timeLabel.text = model.time
        
        switch model.status {
        case .pending:
            configureForPending()
        case .booked:
            // wait for inCalendar to set..
            break
        case .past:
            configureForPast()
        }
    }
    
    // MARK: Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reservationButton.setTitleColor(Colors.DarkBlue, for: .normal)
        backgroundImageView.image = Images.ReservationCell.DefaultBackground
    }
    
    // MARK: IBAction
    
    @IBAction func tapActionButton(_ sender: UIButton) {
        MixpanelHelper.buttonTap("ReservationCellAction")
        guard let model = model else { return }
        
        switch model.status {
        case .pending:
            upcomingDelegate?.presentReservationDetails(self)
        case .booked:
            if inCalendar == true {
                upcomingDelegate?.presentReservationDetails(self)
            } else {
                upcomingDelegate?.addReservationToCalendar(self)
            }
        case .past:
            pastDelegate?.presentBookAgain(self)
        }
    }
}

// MARK: Configuration

extension ReservationCell {
    func configureForPast() {
        reservationButton.setTitle("Book Again", for: .normal)
        reservationButton.setTitleColor(Colors.DarkBlue, for: .normal)
        backgroundImageView.image = Images.ReservationCell.DefaultBackground
    }
    
    func configureForBooked(_ inCalendar: Bool?) {
        if inCalendar == true {
            reservationButton.setTitle("View Reservation", for: .normal)
        } else {
            reservationButton.setTitle("Add to Calendar", for: .normal)
        }
        reservationButton.setTitleColor(Colors.DarkBlue, for: .normal)
        backgroundImageView.image = Images.ReservationCell.DefaultBackground
    }
    
    func configureForPending() {
        reservationButton.setTitle("View Reservation", for: .normal)
        reservationButton.setTitleColor(Colors.GrayBlue, for: .normal)
        if UIDevice.current.userInterfaceIdiom == .pad || UIScreen.main.sizeType == .iPhone4 {
            backgroundImageView.image = Images.ReservationCell.SquarePending
        } else {
            backgroundImageView.image = Images.ReservationCell.PendingBackground
        }
    }
}

// MARK: Class Func

extension ReservationCell {
    class func identifier() -> String {
        if UIDevice.current.userInterfaceIdiom == .pad || UIScreen.main.sizeType == .iPhone4 {
            return "SquareReservationCellIdentifier"
        } else {
            return "ReservationCellIdentifier"
        }
    }
}
