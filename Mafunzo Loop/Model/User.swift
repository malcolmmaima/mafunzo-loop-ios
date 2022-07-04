//
//  User.swift
//  Mafunzo Loop
//
//  Created by mroot on 30/06/2022.
//

import Foundation

class User: Codable, ObservableObject, Identifiable {
    enum CodingKeys: CodingKey {
        case mobileNumber
        case firstName
        case lastName
        case email
        case accountType
        case schools
        case dateCreated
        case profilePic
    }
    
    @Published var mobileNumber: Int = 0
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var accountType = ""
    @Published var schools = ""
    @Published var dateCreated: Int = 0
    @Published var profilePic = ""
    
    init() {}
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        mobileNumber = try container.decode(Int.self, forKey: .mobileNumber)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        accountType = try container.decode(String.self, forKey: .accountType)
        schools = try container.decode(String.self, forKey: .schools)
        dateCreated = try container.decode(Int.self, forKey: .dateCreated)
        profilePic = try container.decode(String.self, forKey: .profilePic)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mobileNumber, forKey: .mobileNumber)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(email, forKey: .email)
        try container.encode(accountType, forKey: .accountType)
        try container.encode(schools, forKey: .schools)
        try container.encode(dateCreated, forKey: .dateCreated)
        try container.encode(profilePic, forKey: .profilePic)
    }
}
