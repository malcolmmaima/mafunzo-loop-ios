//
//  Teacher.swift
//  Mafunzo Loop
//
//  Created by Mroot on 30/07/2022.
//

import Foundation

struct Teacher: Codable {
    let bio: String
    let dateCreated: Int
    let emailAddress: String
    let firstName: String
    let grades: [String]
    let id: String
    let lastName: String
    let phoneNumber: String
    let profilePic: String
    let status: String // Change to Bool
    let subjects: [String]
}
