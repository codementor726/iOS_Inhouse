//
//  AvailableReservationCell.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/13/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit

protocol AvailableReservationCellDelegate: class {
    func requestReservation(_ cell: AvailableReservationCell)
    func bookReservationAtTime(_ cell: AvailableReservationCell, timeslot: Timeslot)
}

fileprivate let cellWidth: CGFloat = 73

class AvailableReservationCell: UICollectionViewCell {
    
    // MARK: Variables
    
    var model: AvailableReservationModel? {
        didSet {
            if let model = model {
                configure(model)
            }
        }
    }
    weak var delegate: AvailableReservationCellDelegate?
    
    // MARK: IBOutlet
    
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var secondTimeslotWidth: NSLayoutConstraint!
    @IBOutlet weak var neighborhoodLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var secondTimeslotButton: UIButton!
    @IBOutlet weak var firstTimeslotButton: UIButton!
    
    // MARK: Setup
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addDropShadow()
    }
    
    // MARK: Configure
    
    private func configure(_ model: AvailableReservationModel) {
        restaurantNameLabel.text = model.restaurant
        neighborhoodLabel.text = model.neighborhood
        addressLabel.text = model.address
        
        if let timeslots = model.timeslots {
            switch timeslots.count {
            case 2:
                firstTimeslotButton.isHidden = false
                firstTimeslotButton.setTitle(timeslots[1].time, for: .normal)
                secondTimeslotWidth.constant = cellWidth
                secondTimeslotButton.setTitle(timeslots.first?.time, for: .normal)
            case 1:
                firstTimeslotButton.isHidden = false
                firstTimeslotButton.setTitle("Request", for: .normal)
                firstTimeslotButton.setTitle(timeslots.first?.time, for: .normal)
                secondTimeslotWidth.constant = 0
            default:
                firstTimeslotButton.isHidden = false
                firstTimeslotButton.setTitle("Request", for: .normal)
                secondTimeslotWidth.constant = 0
            }
        }
    }
    
    // MARK: Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        firstTimeslotButton.isHidden = false
        firstTimeslotButton.setTitle("Request", for: .normal)
        secondTimeslotWidth.constant = 0
    }
    
    // MARK: IBAction
    
    @IBAction func tapFirstTimeslot(_ sender: UIButton) {
        MixpanelHelper.buttonTap("RestaurantAvailabilityFirstButton")
        if model?.timeslots?.count == 2, let timeslot = model?.timeslots?[1] {
            delegate?.bookReservationAtTime(self, timeslot: timeslot)
        } else if model?.timeslots?.count == 1, let timeslot = model?.timeslots?.first {
            delegate?.bookReservationAtTime(self, timeslot: timeslot)
        } else {
            delegate?.requestReservation(self)
        }
    }
    
    @IBAction func tapSecondTimeslot(_ sender: UIButton) {
        MixpanelHelper.buttonTap("RestaurantAvailabilitySecondButton")
        if let timeslot = model?.timeslots?.first {
            delegate?.bookReservationAtTime(self, timeslot: timeslot)
        }
    }
}

// MARK: Class Func

extension AvailableReservationCell {
    class func height() -> CGFloat {
        return 120.0
    }
    
    class func identifier() -> String {
        return "AvailableReservationCellIdentifier"
    }
}
