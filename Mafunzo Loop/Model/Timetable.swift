//
//  Subject.swift
//  Mafunzo Loop
//
//  Created by Mroot on 03/08/2022.
//

import Foundation

struct Timetable: Codable {
    var assignedTeacher: String
    var dayOfWeek: Int
    var endTime: Int
    var startTime: Int
    var subjectName: String
}
