//
//  DateConverter.swift
//  Mafunzo Loop
//
//  Created by Mroot on 23/08/2022.
//

import Foundation

class DateConverter {
    // MARK: DATE -> 22 Aug
    func getDate(date: Int) -> String {
        let day = Date(timeIntervalSince1970: (Double(date) / 1000.0))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM"
        return dateFormatter.string(from: day)
    }
    
    // MARK: Date and Time -> 22 Aug, 2:00 pm
    func Date_Time(date: Int) -> String {
        let timeStamp = Date(timeIntervalSince1970: TimeInterval(date))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM, h:mm a"
        return dateFormatter.string(from: timeStamp)
    }
    
    // MARK: Time to Hour & Min (10:00 AM/PM)
    func TimeSpan(time: Int) -> String {
        let stating = Date(timeIntervalSince1970: (Double(time) / 1000.0))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: stating)
    }
}
