//
//  CalendarHelper.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/29/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import EventKit

func calendarAccessDetermined()-> Bool {
    return UserDefaults.standard.value(forKey: "CalendarAccessDetermined") as? Bool ?? false
}

func calendarAuthorized()-> Bool {
    return EKEventStore.authorizationStatus(for: .event) == .authorized
}

struct CalendarHelper {
    
    // MARK: Saving
    
    static func saveToCalendar(_ start: Date, end: Date, title: String, notes: String?, center: CLLocationCoordinate2D) {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event, completion:{(granted, error) in
            if granted && error == nil {
                Printer.print("granted \(granted)")
                Printer.print("error \(String(describing: error))")
                
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = start
                event.endDate = end
                event.notes = notes
                event.calendar = eventStore.defaultCalendarForNewEvents
                let attd = createParticipant("membership@inhousenewyork.com")
                event.setValue(attd, forKey: "organizer")
                let location = CLLocation(latitude: center.latitude, longitude: center.longitude)
                let structuredLocation = EKStructuredLocation(title: title)
                structuredLocation.geoLocation = location
                event.structuredLocation = structuredLocation
                
                var event_id: String?
                do {
                    try eventStore.save(event, span: .thisEvent)
                    event_id = event.eventIdentifier
                }
                catch let error as NSError {
                    Printer.print("json error: \(error.localizedDescription)")
                }
                if event_id != nil {
                    Printer.print("event added !")
                }
            }
        })
    }
    
    static func saveReservationBooking(_ model: ReservationBookingModel) {
        guard let timeDate = model.timeslot.time?.covertFormattedStringToDate("h:mma") else { assertionFailure()
            return
        }
        
        let startDate = Date.init(year: model.date.year, month: model.date.month, day: model.date.day, hour: timeDate.hour, minute: timeDate.minute, second: 0)
        let endDate = Date.init(year: model.date.year, month: model.date.month, day: model.date.day, hour: timeDate.hour + 1, minute: timeDate.minute, second: 0)
        let title = "Dinner for \(model.partySize)ppl @ \(model.restaurant.name ?? "") - INHOUSE"
        
        CalendarHelper.saveToCalendar(startDate, end: endDate, title: title, notes: nil, center: model.restaurant.center ?? currentCity.center)
    }
    
    static func saveReservation(_ reservation: Reservation) {
        if let timeDate = reservation.time?.covertFormattedStringToDate("h:mma") ?? reservation.prefTime, let dayDate = reservation.date.convertApiDateStringToDate() {
            let startDate = Date.init(year: dayDate.year, month: dayDate.month, day: dayDate.day, hour: timeDate.hour, minute: timeDate.minute, second: 0)
            let endDate = Date.init(year: dayDate.year, month: dayDate.month, day: dayDate.day, hour: timeDate.hour + 1, minute: timeDate.minute, second: 0)
            let title = "Dinner for \(reservation.partySize ?? 2)ppl @ \(reservation.restaurant.name ?? "") - INHOUSE"
            
            CalendarHelper.saveToCalendar(startDate, end: endDate, title: title, notes: nil, center: reservation.restaurant.center ?? currentCity.center)
        }
    }
    
    // MARK: Exists
    
    static func reservationExists(_ reservation: Reservation, completion: @escaping (_ inCalendar: Bool)->Void) {
        if let timeDate = reservation.time?.covertFormattedStringToDate("h:mma") ?? reservation.prefTime, let dayDate = reservation.date.convertApiDateStringToDate() {
            let startDate = Date.init(year: dayDate.year, month: dayDate.month, day: dayDate.day, hour: timeDate.hour, minute: timeDate.minute, second: 0)
            let endDate = Date.init(year: dayDate.year, month: dayDate.month, day: dayDate.day, hour: timeDate.hour + 1, minute: timeDate.minute, second: 0)
            let title = "Dinner for \(reservation.partySize ?? 2)ppl @ \(reservation.restaurant.name ?? "") - INHOUSE"
            
            CalendarHelper.eventExists(startDate, end: endDate, title: title) { (inCalendar) in
                completion(inCalendar)
            }
        } else {
            completion(false)
        }
    }
    
    static func eventExists(_ start: Date, end: Date, title: String, completion: @escaping (_ inCalendar: Bool)->Void) {
        DispatchQueue.global(qos: .background).async {
            let eventStore = EKEventStore()
            let predicate = eventStore.predicateForEvents(withStart: start, end: end, calendars: nil)
            let existingEvents = eventStore.events(matching: predicate)
            DispatchQueue.main.async {
                if let _ = existingEvents.index(where: { $0.title == title && $0.startDate == start}) {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    // MARK: Helper
    
    private static func createParticipant(_ email: String) -> EKParticipant? {
        let clazz: AnyClass? = NSClassFromString("EKAttendee")
        if let type = clazz as? NSObject.Type {
            let attendee = type.init()
            attendee.setValue(email, forKey: "emailAddress")
            return attendee as? EKParticipant
        }
        return nil
    }
}
