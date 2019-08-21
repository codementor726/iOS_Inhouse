//
//  RestaurantBookingViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/12/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit
import Mapbox

class RestaurantBookingViewController: UIViewController {
    
    // MARK: Variables
    
    public var model: RestaurantBookingModel?
    
    // MARK: IBOutlet
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var reservationTimesView: UIView!
    @IBOutlet weak var reservationRequestView: UIView!
    @IBOutlet weak var firstInventoryButton: UIButton!
    @IBOutlet weak var firstInventoryWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondInventoryButton: UIButton!
    @IBOutlet weak var leftTagLabel: UILabel!
    @IBOutlet weak var rightTagLabel: UILabel!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let model = model {
            configure(model)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MixpanelHelper.screenView("RestaurantBooking")
    }
    
    // MARK: Configure
    
    func configure(_ model: RestaurantBookingModel) {
        nameLabel.text = model.restaurant.name
        addressLabel.text = model.restaurant.crossStreets
        descriptionLabel.text = model.restaurant.description
        partyLabel.text = "Party of \(model.partySize)"
        dateLabel.text = model.date.stringWithFormat("MMM d, yyyy")
        leftTagLabel.text = model.restaurant.tagOne
        rightTagLabel.text = model.restaurant.neighborhood
        
        if let timeslots = model.timeslots {
            switch timeslots.count {
            case 2:
                firstInventoryButton.isHidden = false
                firstInventoryButton.setTitle(timeslots[1].time, for: .normal)
                secondInventoryButton.isHidden = false
                secondInventoryButton.setTitle(timeslots.first?.time, for: .normal)
            case 1:
                secondInventoryButton.isHidden = false
                secondInventoryButton.setTitle(timeslots.first?.time, for: .normal)
                firstInventoryWidthConstraint.constant = 0
            case 0:
                reservationTimesView.isHidden = true
            default:
                break
            }
        } else {
            reservationTimesView.isHidden = true
        }
        
        if let restaurantCenter = model.restaurant.center {
            mapView.setCenter(restaurantCenter, zoomLevel: 15, animated: false)
            let restaurant = MGLPointAnnotation()
            restaurant.coordinate = restaurantCenter
            mapView.addAnnotation(restaurant)
        } else {
            mapView.setCenter(currentCity.center, zoomLevel: currentCity.zoom, animated: false)
        }
    }
    
    // MARK: IBAction
    
    @IBAction func tapFirstInventory(_ sender: UIButton) {
        MixpanelHelper.buttonTap("RestaurantBookingFirstInventory")
        guard let model = model, let timeslot = model.timeslots?[1] else { assertionFailure()
            return
        }
        let bookingModel = ReservationBookingModel.init(model.restaurant, date: model.date, timeslot: timeslot, partySize: model.partySize)
        navigationController?.pushReservationBooking(bookingModel)
    }
    
    @IBAction func tapSecondInventory(_ sender: UIButton) {
        MixpanelHelper.buttonTap("RestaurantBookingSecondInventory")
        guard let model = model, let timeslot = model.timeslots?.first else { assertionFailure()
            return
        }
        let bookingModel = ReservationBookingModel.init(model.restaurant, date: model.date, timeslot: timeslot, partySize: model.partySize)
        navigationController?.pushReservationBooking(bookingModel)
    }
    
    @IBAction func tapRequest(_ sender: UIButton) {
        MixpanelHelper.buttonTap("RestaurantBookingRequest")
        guard let model = model else { assertionFailure()
            return
        }
        let requestModel = ReservationRequestModel.init(model.restaurant, date: model.date, partySize: model.partySize)
        navigationController?.pushReservationRequest(requestModel)
    }
    
    @IBAction func tapMap(_ sender: UIButton) {
        guard let restaurant = model?.restaurant.name, let lat = model?.restaurant.lat, let long = model?.restaurant.long else { return }
        
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            openInGoogleMaps(coord: (lat, long), q: restaurant)
        } else if UIApplication.shared.canOpenURL(URL(string:"http://maps.apple.com")!) {
            openInAppleMaps(coord: (lat, long), q: restaurant)
        }
    }
    
    @IBAction func tapMenus(_ sender: UIButton) {
        MixpanelHelper.buttonTap("Menus")
        if let menus = model?.restaurant.menus {
            presentWebsite(URL.init(string: menus), titleString: "Menus")
        } else {
            showMessage(nil, title: "Menus Not Available")
        }
    }
    
    @IBAction func tapWine(_ sender: UIButton) {
        MixpanelHelper.buttonTap("Wine")
        if let wine = model?.restaurant.wine {
            presentWebsite(URL.init(string: wine), titleString: "Wine")
        } else {
            showMessage(nil, title: "Wine List Not Available")
        }
    }
    
    @IBAction func tapWebsite(_ sender: UIButton) {
        MixpanelHelper.buttonTap("Website")
        if let website = model?.restaurant.website {
            presentWebsite(URL.init(string: website), titleString: model?.restaurant.name)
        } else {
            showMessage(nil, title: "Website Not Available")
        }
    }
}

// MARK: Class Func

extension RestaurantBookingViewController {
    class func identifier() -> String {
        return "RestaurantDetailsViewControllerIdentifier"
    }
}
