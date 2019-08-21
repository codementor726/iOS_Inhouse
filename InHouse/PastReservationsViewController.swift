//
//  PastReservationsViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/18/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import XLPagerTabStrip

class PastReservationsViewController: ReservationsViewController, IndicatorInfoProvider {
    
    // MARK: View Lifeycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MixpanelHelper.screenView("PastReservations")
    }
    
    // MARK: IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Past\(reservations != nil ? " (\(reservations!.count))" : "")")
    }
    
    // MARK: Class Func
    
    class func identifier() -> String {
        return "PastReservationsViewControllerIdentifier"
    }
}

// MARK: UICollectionViewDataSource

extension PastReservationsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reservations?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReservationCell.identifier(), for: indexPath) as! ReservationCell
        cell.pastDelegate = self
        if let reservation = reservations?[indexPath.row] {
            cell.model = ReservationViewModel.init(reservation, status: .past)
        }
        return cell
    }
}

// MARK: UICollectionViewDelegate

extension PastReservationsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: UIScreen.main.bounds.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        MixpanelHelper.buttonTap("ViewReservation")
        if let reservation = reservations?[indexPath.row] {
            pushBookAgain(reservation)
        }
    }
}

// MARK: ReservationCellDelegate

extension PastReservationsViewController: PastReservationCellDelegate {
    func presentBookAgain(_ cell: ReservationCell) {
        if let index = reservationsCollectionView.indexPath(for: cell)?.row, let reservation = reservations?[index] {
            pushBookAgain(reservation)
        }
    }
}
