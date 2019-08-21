//
//  Images.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/18/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit

struct Images {
    struct Headers {
        public static let InHouseHeader = #imageLiteral(resourceName: "inhouseHeader")
    }
    
    struct Misc {
        public static let SliderIcon = #imageLiteral(resourceName: "sliderIcon")
    }
    
    struct PageControl {
        public static let Selected = #imageLiteral(resourceName: "selectedPagerCircle")
        public static let Unselected = #imageLiteral(resourceName: "unselectedPagerCircle")
    }
    
    struct Tutorial {
        public static let One = #imageLiteral(resourceName: "tutorialOne")
        public static let Two = #imageLiteral(resourceName: "tutorialTwo")
        public static let Three = #imageLiteral(resourceName: "tutorialThree")
        public static let Four = #imageLiteral(resourceName: "tutorialFour")
    }
    
    struct PathMenu {
        public static let AZ = #imageLiteral(resourceName: "circleAZIcon")
        public static let Calendar = #imageLiteral(resourceName: "circleCalendarIcon")
        public static let Map = #imageLiteral(resourceName: "circleGlobeIcon")
        public static let Reservations = #imageLiteral(resourceName: "circleReservationsIcon")
    }
    
    struct ReservationCell {
        public static let DefaultBackground = #imageLiteral(resourceName: "reservationCellImage")
        public static let PendingBackground = #imageLiteral(resourceName: "pendingBackground")
        public static let SquarePending = #imageLiteral(resourceName: "squarePending")
    }
    
    struct NewsFeed {
        public static let NotLikedIcon = #imageLiteral(resourceName: "heartEmpty")
        public static let LikedIcon = #imageLiteral(resourceName: "heartFilled")
    }
}
