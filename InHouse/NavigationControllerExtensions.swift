//
//  NavigationControllerExtensions.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/30/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit
import MZFormSheetPresentationController

// MARK: Navigation Controller

extension UINavigationController {
    var rootViewController : UIViewController? {
        return viewControllers.first
    }
    
    // MARK: Push
    
    func pushRestaurantBooking(_ model: RestaurantBookingModel) {
        let restaurantDetails = UIStoryboard.init(name: "Reservations", bundle: nil).instantiateViewController(withIdentifier: RestaurantBookingViewController.identifier()) as! RestaurantBookingViewController
        restaurantDetails.model = model
        pushViewController(restaurantDetails, animated: true)
    }
    
    func pushReservationDetails(_ model: ReservationDetailsModel) {
        let reservationDetails = UIStoryboard.init(name: "Reservations", bundle: nil).instantiateViewController(withIdentifier: ReservationDetailsViewController.identifier()) as! ReservationDetailsViewController
        reservationDetails.model = model
        pushViewController(reservationDetails, animated: true)
    }
    
    func pushReservationRequest(_ model: ReservationRequestModel) {
        let reservationRequest = ReservationRequestViewController.makeReservationRequestVC(model: model)
        pushViewController(reservationRequest, animated: true)
    }
    
    func pushReservationBooking(_ model: ReservationBookingModel) {
        let reservationBooking = ReservationBookingViewController.makeReservationBookingVC(model: model)
        pushViewController(reservationBooking, animated: true)
    }
    
    func pushBookByAZ() {
        let bookByAZ = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: BookByAlphabeticalViewController.identifier())
        pushViewController(bookByAZ, animated: true)
    }
    
    func pushUpcomingReservations() {
        let upcomingVC = UIStoryboard.init(name: "Reservations", bundle: nil).instantiateInitialViewController() as! ReservationsPagerViewController
        pushViewController(upcomingVC, animated: true)
    }
    
    // MARK: Popup
    
    func showSuccessfulReservationPopup(_ model: ReservationSuccessViewModel, delegate: ReservationSuccessPopupViewDelegate) {
        let popup = UIStoryboard.init(name: "Popups", bundle: nil).instantiateViewController(withIdentifier: ReservationSuccessPopupViewController.identifier()) as! ReservationSuccessPopupViewController
        popup.model = model
        popup.delegate = delegate
        
        let formSheet = MZFormSheetPresentationViewController.init(contentViewController: popup)
        formSheet.presentationController?.contentViewSize = CGSize.init(width: UIScreen.main.bounds.width - 60, height: 370)
        formSheet.contentViewControllerTransitionStyle = .dropDown
        formSheet.presentationController?.shouldCenterVertically = true
        present(formSheet, animated: true, completion: nil)
    }
    
    func showErrorReservationPopup(_ model: ReservationErrorPopupViewModel, delegate: ReservationErrorPopupViewDelegate) {
        let popup = UIStoryboard.init(name: "Popups", bundle: nil).instantiateViewController(withIdentifier: ReservationErrorPopupViewController.identifier()) as! ReservationErrorPopupViewController
        popup.model = model
        popup.delegate = delegate
        
        let formSheet = MZFormSheetPresentationViewController.init(contentViewController: popup)
        formSheet.presentationController?.contentViewSize = CGSize.init(width: UIScreen.main.bounds.width - 60, height: 370)
        formSheet.contentViewControllerTransitionStyle = .dropDown
        formSheet.presentationController?.shouldCenterVertically = true
        present(formSheet, animated: true, completion: nil)
    }
}
