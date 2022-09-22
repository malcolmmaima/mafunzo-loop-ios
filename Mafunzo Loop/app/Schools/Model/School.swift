//
//  School.swift
//  Mafunzo Loop
//
//  Created by mroot on 14/09/2022.
//

import Foundation

struct School: Codable, Identifiable {
    var id: String
    var schoolLocation: String
    var schoolName: String
    var schoolEmail: String
}

struct Schools: Codable {
    var schoolID: [String: Bool]
}

struct SelectedSchool: Codable {
    var id: String
    var schoolLocation: String
    var schoolName: String
    var schoolEmail: String
}
