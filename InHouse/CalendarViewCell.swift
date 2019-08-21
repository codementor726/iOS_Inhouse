//
//  CalendarViewCell.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/20/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import JTAppleCalendar

fileprivate let Identifier = "CalendarViewCellIdentifier"

class CalendarViewCell: JTAppleCell {
    
    // MARK: IBOutlet

    @IBOutlet weak var dayLabel: UILabel!
    
    // MARK: Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setDeselected()
    }
}

// MARK: Class Func

extension CalendarViewCell {
    class func identifier() -> String {
        return Identifier
    }
}

// MARK: Select

extension CalendarViewCell {
    public func setToday() {
        dayLabel.backgroundColor = Colors.LightGray
        dayLabel.textColor = Colors.DarkBlue
    }
    
    public func setSelected() {
        dayLabel.backgroundColor = Colors.OffRed
        dayLabel.textColor = .white
        
    }
    
    public func setDeselected() {
        dayLabel.backgroundColor = .white
        dayLabel.textColor = Colors.DarkBlue
    }
}
