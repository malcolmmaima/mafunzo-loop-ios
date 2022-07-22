//
//  Calendar.swift
//  Mafunzo Loop
//
//  Created by Mroot on 22/07/2022.
//

import Foundation

struct CalendarEvents: Codable {
    let id: String
    let description: String
    let end: String
    let start: String
    let location: String
    let title: String
}
