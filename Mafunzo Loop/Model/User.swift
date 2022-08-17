//
//  User.swift
//  Mafunzo Loop
//
//  Created by mroot on 30/06/2022.
//

import Foundation

class User: Codable, ObservableObject, Identifiable {
    enum CodingKeys: CodingKey {
        case accountType
        case dateCreated
        case email
        case phone
        case enabled
        case firstName
        case lastName
        case schools
        case profilePic
    }
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var phone = ""
    @Published var enabled: Bool = false
    @Published var accountType = ""
    @Published var schools: [SchoolData] = []
    @Published var dateCreated: Int = 0
    @Published var profilePic = ""
    init() {}
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        accountType = try container.decode(String.self, forKey: .accountType)
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)
        enabled = try container.decode(Bool.self, forKey: .enabled)
//        schools = try container.decode([SchoolData].self, forKey: .schools)
        dateCreated = try container.decode(Int.self, forKey: .dateCreated)
        profilePic = try container.decode(String.self, forKey: .profilePic)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(email, forKey: .email)
        try container.encode(phone, forKey: .phone)
        try container.encode(enabled, forKey: .enabled)
        try container.encode(accountType, forKey: .accountType)
//        try container.encode(schools, forKey: .schools)
        try container.encode(dateCreated, forKey: .dateCreated)
        try container.encode(profilePic, forKey: .profilePic)
    }
}

struct SchoolData: Codable, Identifiable {
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

struct Account_Types: Codable {
    var users: [String]
}
