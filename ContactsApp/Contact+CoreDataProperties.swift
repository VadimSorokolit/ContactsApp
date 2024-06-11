//
//  Contact+CoreDataProperties.swift
//  ContactsApp
//
//  Created by Vadim  on 11.06.2024.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var name: String?
    @NSManaged public var jobPosition: String?
    @NSManaged public var email: String?
    @NSManaged public var photo: NSObject?

}

extension Contact : Identifiable {

}
