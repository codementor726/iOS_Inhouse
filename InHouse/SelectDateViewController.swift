//
//  SelectDateViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/20/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit
import JTAppleCalendar

class SelectDateViewController: UIViewController {
    
    // MARK: Variables
    
    var selected: Date = Date.tomorrow()
    
    // MARK: Views
    
    @IBOutlet weak var calendarView: CalendarView!

    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        navigationItem.title = "INHOUSE"
        calendarView.delegate = self
        calendarView.jtCalendarView.cellSize = (UIScreen.main.bounds.width - 40)/7
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MixpanelHelper.screenView("SelectDate")
    }
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        MixpanelHelper.buttonTap("SelectDateNext")
        if segue.identifier == "Next" {
            guard let destination = segue.destination as? BookByDateViewController else { return }
            destination.date = selected
        }
    }
}

// MARK: CalendarViewDelegate

extension SelectDateViewController: CalendarViewDelegate {
    func selectedDateChanged(_ date: Date) {
        selected = date
    }
}

// MARK: Class Func

extension SelectDateViewController {
    class func identifier()-> String {
        return "SelectDateViewControllerIdentifier"
    }
}
