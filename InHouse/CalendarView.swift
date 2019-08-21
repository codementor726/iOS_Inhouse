//
//  CalendarViewContainer.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/20/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import JTAppleCalendar

protocol CalendarViewDelegate: class {
    func selectedDateChanged(_ date: Date)
}

class CalendarView: UIView {
    
    // MARK:  Variables
    
    var selected: Date = Date.tomorrow() {
        didSet {
            delegate?.selectedDateChanged(selected)
        }
    }
    var selectedCell: CalendarViewCell? {
        didSet {
            if selectedCell?.dayLabel.text == "\(selected.day)" {
                selectedCell?.setSelected()
            }
        }
    }
    weak var delegate: CalendarViewDelegate?

    // MARK: IBOutlet
    
    @IBOutlet weak fileprivate var topLabel: UILabel!
    @IBOutlet weak var jtCalendarView: JTAppleCalendarView!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    // MARK: Setup
    
    override func awakeFromNib() {
        super.awakeFromNib()
        jtCalendarView.calendarDataSource = self
        jtCalendarView.calendarDelegate = self
        jtCalendarView.scrollingMode = .stopAtEachCalendarFrame
        jtCalendarView.register(UINib.init(nibName: "CalendarCellView", bundle: nil), forCellWithReuseIdentifier: CalendarViewCell.identifier())
        jtCalendarView.allowsMultipleSelection = false 

        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        let monthString = formatter.monthSymbols[Date().month - 1]
        topLabel.text = "\(monthString.capitalized) \(Date().year)"
    }
    
    // MARK: IBAction
    
    @IBAction func tapNext(_ sender: UIButton) {
        jtCalendarView.scrollToSegment(.next, triggerScrollToDateDelegate: true, animateScroll: true, extraAddedOffset: 0.0, completionHandler: nil)
    }
    
    @IBAction func tapPrevious(_ sender: UIButton) {
        jtCalendarView.scrollToSegment(.previous, triggerScrollToDateDelegate: true, animateScroll: true, extraAddedOffset: 0.0, completionHandler: nil)
    }
}

// MARK: DataSource/Delegate

extension CalendarView: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        // Not optional
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let startDate = Date.tomorrow()
        let endDate = Date.init(year: startDate.year + 1, month: 12, day: 31)
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6,
                                                 calendar: Calendar.current,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .off,
                                                 firstDayOfWeek: .sunday)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth && !Calendar.current.isDate(date, inSameDayAs: Date()) && date > Date() {
            let selectedCell = (cell as? CalendarViewCell)
            if selected.month == date.month {
                self.selectedCell?.setDeselected()
            }
            selected = date
            self.selectedCell = selectedCell
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: CalendarViewCell.identifier(), for: indexPath) as! CalendarViewCell
        cell.dayLabel.text = cellState.text
        cell.dayLabel.textColor = (cellState.dateBelongsTo == .thisMonth && date >= Date()) ? Colors.DarkBlue : .clear
        
        if Calendar.current.isDateInToday(date) && cellState.dateBelongsTo == .thisMonth {
            cell.setToday()
        }
        if Calendar.current.isDate(selected, inSameDayAs: date) && cellState.dateBelongsTo == .thisMonth {
            selectedCell = cell
        }
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        guard let monthNumber = visibleDates.monthDates.first?.date.month, let yearNumber = visibleDates.monthDates.first?.date.year else { return }
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        let monthString = formatter.monthSymbols[monthNumber - 1]
        topLabel.text = "\(monthString.capitalized) \(yearNumber)"
    }
}
