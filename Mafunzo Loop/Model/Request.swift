//
//  Request.swift
//  Mafunzo Loop
//
//  Created by Mroot on 28/07/2022.
//

import Foundation

/*
 createdAt              1658412091386
 id                 "Cu91v5vXmvWdJX7RUywj"
 message                "pending"
 status                 "PENDING"
 subject                "Pending request"
 type               "GENERAL_REQUEST"
 */
class Request: Codable, ObservableObject, Identifiable {
    enum CodingKeys: CodingKey {
        case createdAt
        case id
        case message
        case status
        case subject
        case type
    }
    
    @Published var createdAt: Int = 0
    @Published var id = ""
    @Published var message = ""
    @Published var status = "PENDING"
    @Published var subject = ""
    @Published var type = ""
    
    init() {}
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        createdAt = try container.decode(Int.self, forKey: .createdAt)
        id = try container.decode(String.self, forKey: .id)
        message = try container.decode(String.self, forKey: .message)
        status = try container.decode(String.self, forKey: .status)
        subject = try container.decode(String.self, forKey: .subject)
        type = try container.decode(String.self, forKey: .type)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(message, forKey: .message)
        try container.encode(status, forKey: .status)
        try container.encode(subject, forKey: .subject)
        try container.encode(type, forKey: .type)
    }
}

struct Request_Types: Codable {
    var types: [String]
}
