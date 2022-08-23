//
//  Constants.swift
//  Mafunzo Loop
//
//  Created by Mroot on 23/08/2022.
//

import Foundation
import Firebase

enum UserDetails {
    static let userNumber = UserDefaults.standard.string(forKey: "userNumber") ?? ""
    static let userType = UserDefaults.standard.string(forKey: "userAccount") ?? ""
    static let currentSchoolID = UserDefaults.standard.string(forKey: "schoolID") ?? ""
    static let userSchools = UserDefaults.standard.stringArray(forKey: "schoolID's")  ?? [String]() //school IDs [String]
    static let schoolArray = (UserDefaults.standard.object(forKey: "schoolArray")  as? [String:Bool])! // School Dictionary [String: Bool]
}
