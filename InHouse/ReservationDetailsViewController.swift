//
//  ReservationDetailsViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/24/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit
import Mapbox

class ReservationDetailsViewController: UIViewController {
    
    // MARK: Variables
    
    public var model: ReservationDetailsModel?
    
    // MARK: IBOutlet
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mapView: MGLMapView!
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
        MixpanelHelper.screenView("ReservationDetails")
    }
    
    // MARK: Configure
    
    func configure(_ model: ReservationDetailsModel) {
        nameLabel.text = model.restaurant.name
        addressLabel.text = model.restaurant.crossStreets
        descriptionLabel.text = model.restaurant.description
        partyLabel.text = "Party of \(model.partySize)"
        dateLabel.text = model.date.stringWithFormat("EEEE, MMMM d, yyyy")
        timeLabel.text = model.time
        leftTagLabel.text = model.restaurant.tagOne
        rightTagLabel.text = model.restaurant.neighborhood
        
        if let restaurantCenter = model.restaurant.center {
            mapView.setCenter(restaurantCenter, zoomLevel: 15, animated: false)
            let restaurant = MGLPointAnnotation()
            restaurant.coordinate = restaurantCenter
            mapView.addAnnotation(restaurant)
        } else {
            mapView.setCenter(currentCity.center, zoomLevel: currentCity.zoom, animated: false)
        }
    }
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChangeCancel", let changeCancel = segue.destination as? TextUpdateViewController, let model = model, let date = model.date.stringWithFormat("MMMM d") {
            MixpanelHelper.buttonTap("ChangeCancelReservation")
            
            let baseString = "\(model.restaurant.name != nil ? "\(model.restaurant.name!), " : "")\(model.partySize)ppl on \(date)\(model.time != nil ? " @ \(model.time!)" : "")"
            changeCancel.baseString = baseString
        }
    }
    
    // MARK: IBAction
    
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

extension ReservationDetailsViewController {
    class func identifier() -> String {
        return "ReservationDetailsViewControllerIdentifier"
    }
}
