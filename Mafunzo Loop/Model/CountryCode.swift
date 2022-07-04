//
//  CountryCode.swift
//  Mafunzo Loop
//
//  Created by mroot on 01/07/2022.
//

import Foundation

// MARK: - CountryCode
struct CountryCode: Codable {
    let countryCode: [CountryData]
}
struct CountryData: Codable {
    let name, flag, code, dialCode: String

    enum CodingKeys: String, CodingKey {
        case name, flag, code
        case dialCode = "dial_code"
    }
}
