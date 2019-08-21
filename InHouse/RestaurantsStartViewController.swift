//
//  RestaurantsStartViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/17/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit

final class RestaurantsStartViewController: UIViewController {
    
    // MARK: - Variables
    
    @IBOutlet weak var nycButton: UIButton!
    @IBOutlet weak var londonButton: UIButton!
    @IBOutlet weak var upcomingReservationLabel: UILabel!
    @IBOutlet weak var upcomingReservationDateLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var headerSpacer: UIView!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "INHOUSE"
        setDefaultHeaderButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUpcomingDetails()
        refreshUpcomingDetails()
        MixpanelHelper.screenView("RestaurantsStart")
    }
    
    // MARK: - Header
    
    private func updateHeaderButtons() {
        switch currentCity.code {
        case 1:
            nycButton.setTitleColor(Colors.OffWhite, for: .normal)
            londonButton.setTitleColor(Colors.OffWhite.withAlphaComponent(0.5), for: .normal)
            UIView.animate(withDuration: 0.3, animations: {
                self.headerSpacer.frame = self.headerSpacer.frame.offsetBy(dx: -self.headerSpacer.frame.width, dy: 0)
            })
        case 2:
            londonButton.setTitleColor(Colors.OffWhite, for: .normal)
            nycButton.setTitleColor(Colors.OffWhite.withAlphaComponent(0.5), for: .normal)
            UIView.animate(withDuration: 0.3, animations: {
                self.headerSpacer.frame = self.headerSpacer.frame.offsetBy(dx: self.headerSpacer.frame.width, dy: 0)
            })
        default:
            assertionFailure()
        }
    }
    
    private func setDefaultHeaderButtons() {
        switch currentCity.code {
        case 1:
            nycButton.setTitleColor(Colors.OffWhite, for: .normal)
            londonButton.setTitleColor(Colors.OffWhite.withAlphaComponent(0.5), for: .normal)
        case 2:
            londonButton.setTitleColor(Colors.OffWhite, for: .normal)
            nycButton.setTitleColor(Colors.OffWhite.withAlphaComponent(0.5), for: .normal)
        default:
            assertionFailure()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if currentCity.code == 2 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.headerSpacer.frame = self.headerSpacer.frame.offsetBy(dx: self.view.frame.size.width/2, dy: 0)
                })
            }
        }
    }
    
    // MARK: - Upcoming Reservation Info
    
    private func loadUpcomingDetails() {
        InHouseAPI.shared.getFirstUpcomingReservation() { (success, reservation, error) in
            if success, let reservation = reservation {
                UserDefaults.standard.set(reservation.simpleDescription(), forKey: "MostRecentReservation")
                UserDefaults.standard.set(reservation.date, forKey: "MostRecentReservationDate")
                self.refreshUpcomingDetails()
            }
        }
    }
    
    private func refreshUpcomingDetails() {
        upcomingReservationLabel.text = UserDefaults.standard.string(forKey: "MostRecentReservation") ?? "No upcoming reservations"
        if let upcomingDate = UserDefaults.standard.string(forKey: "MostRecentReservationDate") {
            upcomingReservationDateLabel.text = upcomingDate.convertApiDateString("EEEE, MMM d, yyyy")
        } else {
            upcomingReservationDateLabel.text = nil
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func tapNewYork(_ sender: UIButton) {
        if currentCity.code != 1, let nyc = cities.first(where: { $0.code == 1 }) {
            currentCity = nyc
            updateHeaderButtons()
        }
    }
    
    @IBAction func tapLondon(_ sender: UIButton) {
        if currentCity.code != 2, let london = cities.first(where: { $0.code == 2 }) {
            currentCity = london
            updateHeaderButtons()
        }
    }
    
    @IBAction func tapHamburger(_ sender: UIBarButtonItem) {
        presentSettings()
    }
    
    @IBAction func tapUpcoming(_ sender: UIButton) {
        navigationController?.pushUpcomingReservations()
    }
}
