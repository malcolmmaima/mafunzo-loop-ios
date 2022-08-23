//
//  DateConverter.swift
//  Mafunzo Loop
//
//  Created by Mroot on 23/08/2022.
//

import Foundation

class DateConverter {
    // MARK: Date and Time -> 22 Aug, 2:00 pm
    func Date_Time(date: Int) -> String {
        let timeStamp = Date(timeIntervalSince1970: TimeInterval(date))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM, h:mm a"
        return dateFormatter.string(from: timeStamp)
    }
}
