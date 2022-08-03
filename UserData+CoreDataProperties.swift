//
//  UserData+CoreDataProperties.swift
//  Mafunzo Loop
//
//  Created by Mroot on 02/08/2022.
//
//

import Foundation
import CoreData


extension UserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserData> {
        return NSFetchRequest<UserData>(entityName: "UserData")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var email: String?
    @NSManaged public var school: String?
    @NSManaged public var accountType: String?

}

extension UserData : Identifiable {

}
