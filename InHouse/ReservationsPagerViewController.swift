//
//  ReservationsPagerViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/12/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import XLPagerTabStrip

class ReservationsPagerViewController: ButtonBarPagerTabStripViewController {
    
    // MARK: View Controllers
    
    var pastReservationsVC: PastReservationsViewController?
    var upcomingReservationsVC: UpcomingReservationsViewController?
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        settings.style.buttonBarItemTitleColor = Colors.OffWhite
        settings.style.buttonBarBackgroundColor = Colors.DarkBlue
        settings.style.buttonBarItemBackgroundColor = Colors.DarkBlue
        settings.style.selectedBarHeight = 3.0
        settings.style.selectedBarBackgroundColor = Colors.OffWhite
        settings.style.buttonBarItemFont = Fonts.Colfax.Medium(16)
        let spacer = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1))
        spacer.backgroundColor = Colors.GrayBlue.withAlphaComponent(0.12)
        buttonBarView.addSubview(spacer)
        
        super.viewDidLoad()
        
        navigationItem.title = "INHOUSE"
        containerView.isScrollEnabled = false
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = Colors.OffWhite.withAlphaComponent(0.5)
            newCell?.label.textColor = Colors.OffWhite
        }
        
        moveToViewController(at: 1, animated: false)
    
        loadUpcomingReservations()
        loadPastReservations()
    }
    
    // MARK: Load
    
    func loadPastReservations() {
        pastReservationsVC?.state = .loading
        InHouseAPI.shared.getMyPastReservations() { (success, reservations, error)-> Void in
            if success {
                if let past = reservations {
                    self.pastReservationsVC?.state = .success(past)
                }
                self.buttonBarView.reloadData()
            } else {
                self.pastReservationsVC?.state = .error
                self.showMessage("Error Loading Past Reservations", title: "Error")
            }
        }
    }
    
    func loadUpcomingReservations() {
        upcomingReservationsVC?.state = .loading
        InHouseAPI.shared.getMyUpcomingReservations() { (success, reservations, error)-> Void in
            if success, let upcoming = reservations {
                self.upcomingReservationsVC?.state = .success(upcoming)
                self.buttonBarView.reloadData()
                
                UserDefaults.standard.set(upcoming.first?.simpleDescription(), forKey: "MostRecentReservation")
                UserDefaults.standard.set(upcoming.first?.date, forKey: "MostRecentReservationDate")
            } else {
                self.upcomingReservationsVC?.state = .error
                self.showMessage("Error Loading Upcoming Reservations", title: "Error")
            }
        }
    }
    
    // MARK: View Controllers
    
    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let past = storyboard?.instantiateViewController(withIdentifier: PastReservationsViewController.identifier()) as! PastReservationsViewController
        pastReservationsVC = past
        let upcoming = storyboard?.instantiateViewController(withIdentifier: UpcomingReservationsViewController.identifier()) as! UpcomingReservationsViewController
        upcomingReservationsVC = upcoming
        // preload view
        let _ = upcomingReservationsVC?.view
        return [past, upcoming]
    }
    
    // MARK: IBAction
    
    @IBAction func tapSettings(_ sender: UIBarButtonItem) {
        presentSettings()
    }
}
