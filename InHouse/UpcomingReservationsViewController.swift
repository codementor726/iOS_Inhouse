//
//  UpcomingReservationsViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/18/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import XLPagerTabStrip
import EventKit

class UpcomingReservationsViewController: ReservationsViewController, IndicatorInfoProvider {
    
    // MARK: View Lifeycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MixpanelHelper.screenView("UpcomingReservations")
    }
    
    // MARK: IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Upcoming\(reservations != nil ? " (\(reservations!.count))" : "")")
    }
    
    // MARK: Class Func
    
    class func identifier() -> String {
        return "UpcomingReservationsViewControllerIdentifier"
    }
}

// MARK: UICollectionViewDataSource/Delegate

extension UpcomingReservationsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reservations?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReservationCell.identifier(), for: indexPath) as! ReservationCell
        guard let reservation = reservations?[indexPath.row] else { return cell }
        
        cell.upcomingDelegate = self
        cell.model = ReservationViewModel.init(reservation, status: reservation.status)
        
        if reservation.status == .booked {
            switch (calendarAuthorized(), calendarAccessDetermined()) {
            case (true, _):
                CalendarHelper.reservationExists(reservation) { (inCalendar) in
                    cell.inCalendar = inCalendar
                }
            case (false, true):
                cell.inCalendar = true // Imperfect name, but disables "Add To Calendar" from showing to users who have disabled calendar access
            case (false, false):
                cell.inCalendar = false // Want to present the add to calendar screen, can happen if user requests - hasn't seen the grant location screen from booking, and then request goes to booked
            }
        }
        return cell
    }
}

// MARK: UICollectionViewDelegate

extension UpcomingReservationsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: UIScreen.main.bounds.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        MixpanelHelper.buttonTap("ViewReservation")
        if let reservation = reservations?[indexPath.row] {
            pushReservationInformation(reservation)
        }
    }
}

// MARK: ReservationCellDelegate

extension UpcomingReservationsViewController: UpcomingReservationCellDelegate {
    func presentReservationDetails(_ cell: ReservationCell) {
        if let index = reservationsCollectionView.indexPath(for: cell)?.row, let reservation = reservations?[index] {
            pushReservationInformation(reservation)
        }
    }
    
    func addReservationToCalendar(_ cell: ReservationCell) {
        if let index = reservationsCollectionView.indexPath(for: cell)?.row, let reservation = reservations?[index] {
            switch (calendarAccessDetermined(), calendarAuthorized()) {
            case (true, true):
                cell.reservationButton.showLoading()
                CalendarHelper.saveReservation(reservation)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    cell.reservationButton.hideLoading()
                    self.reservationsCollectionView.reloadData()
                }
            case (false, false):
                presentGrantCalendar(self)
            case(true, false):
                showMessage(nil, title: "Adjust Calendar Access in Settings")
            case (false, true):
                assertionFailure("Shoudn't be able to grant access until access determined through prompt")
            }
        }
    }
}
