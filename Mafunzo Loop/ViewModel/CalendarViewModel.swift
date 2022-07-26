//
//  CalendarViewModel.swift
//  Mafunzo Loop
//
//  Created by Mroot on 22/07/2022.
//

import Foundation
import Firebase
class CalendarViewModel: ObservableObject {
    @Published var c = CalendarEvents(id: "", description: "", end: 0, start: 0, location: "", title: "")
    @Published var calendarEvents = [CalendarEvents]()
    @Published var date = Date()
    // MARK: Error
    @Published var showAlert: Bool = false
    @Published var errorMsg = ""
    @Published var verificationCode: String = ""
    //Status
    @Published var isLoading: Bool = false
    //Firebase
    let db = Firestore.firestore()
    
    
    // MARK: Events by Date
    func getEvents(selectedDate: Date) {
        print("Get Date Function \(getDateFormat(date: selectedDate))")
        let dateConverted = getDateFormat(date: selectedDate)
        self.calendarEvents.removeAll()
        print("Here")
        let schoolStored = UserDefaults.standard.string(forKey: "schoolID") ?? ""
        let schoolID = String(describing: schoolStored)
        
        if schoolID != "" {
            let eventRef = db.collection("calendar_events").document(schoolID).collection("PARENT")
                .whereField("start", isGreaterThan: dateConverted)
                .whereField("start", isLessThan: dateConverted + 86400000)
            eventRef.getDocuments { results, error in
                guard error == nil else {
                    print("Error!!! \(error!.localizedDescription)")
                    //self.handleError(error: error!.localizedDescription)
                    return
                }
                if let results = results {
                    for document in results.documents {
                        if document == document {
                            let data = document.data()
                            print("Calendar \(data)")
                            print("Here 3")
                            let id = data["id"] as? String ?? ""
                            let location = data["location"] as? String ?? ""
                            let title = data["title"] as? String ?? ""
                            let description = data["description"] as? String ?? ""
                            let start = data["start"] as? Int ?? 0
                            let end = data["end"] as? Int ?? 0
                            DispatchQueue.main.async {
                            let events = CalendarEvents(id: id, description: description, end: end, start: start, location: location, title: title)
                               self.calendarEvents.append(events)
                               // self.c = events
                                print("Data \(events.title)")
                            }
                        }
                    }
                }
            }
        }
    }
    // MARK: Get Event time in millisecond By Date
    func getDateFormat(date: Date) -> Int {
        let day = date.millisecondsSince1970
        print("Day in Millisecond \(day)")
        let convertDay = Date(timeIntervalSince1970: (Double(day) / 1000.0))
        print("Converted \(convertDay)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        print("New Converted Day \(dateFormatter.string(from: convertDay))")
        let newDate = dateFormatter.string(from: convertDay)
        print("String Date to Date Type: \(dateFormatter.date(from: newDate) ?? Date.now)")
        let dateType = dateFormatter.date(from: newDate)
        let newDateToMilli = dateType?.millisecondsSince1970
       // print("New Date Type to Milli \(newDateToMilli)")
        let millisecondDate = Int(newDateToMilli ?? day)
       // return dateFormatter.string(from: convertDay)
        return millisecondDate
    }
    
    // MARK: Show Upcomming Events
    func showUpcommingEvents() {
        self.calendarEvents.removeAll()
        // MARK: To-Do getDateFormat
        let date = Date.now
        let currentTime = date.millisecondsSince1970
        
        let schoolStored = UserDefaults.standard.string(forKey: "schoolID") ?? ""
        let schoolID = String(describing: schoolStored)
        
        if schoolID != "" {
            let eventRef = db.collection("calendar_events").document(schoolID).collection("PARENT")
                .whereField("start", isGreaterThan: currentTime)
               // .whereField("start", isLessThan: currentTime + 86400000)
            eventRef.getDocuments { results, error in
                guard error == nil else {
                    print("Error!!! \(error!.localizedDescription)")
                    //self.handleError(error: error!.localizedDescription)
                    return
                }
                if let results = results {
                    for document in results.documents {
                        if document == document {
                            let data = document.data()
                            print("Upcomming Calendar \(data)")
                            print("Here 3")
                            let id = data["id"] as? String ?? ""
                            let location = data["location"] as? String ?? ""
                            let title = data["title"] as? String ?? ""
                            let description = data["description"] as? String ?? ""
                            let start = data["start"] as? Int ?? 0
                            let end = data["end"] as? Int ?? 0
                            DispatchQueue.main.async {
                            let events = CalendarEvents(id: id, description: description, end: end, start: start, location: location, title: title)
                               self.calendarEvents.append(events)
                               // self.c = events
                                print("Data \(events.title)")
                            }
                        }
                    }
                }
            }
        }
    }
}
