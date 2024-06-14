//
//  Contact+CoreDataProperties.swift
//  ContactsApp
//
//  Created by Vadym Sorokolit on 12.06.2024.
//

import Foundation
import UIKit
import CoreData


extension Contact {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var fullName: String?
    @NSManaged public var jobPosition: String?
    @NSManaged public var email: String?
    @NSManaged public var photo: UIImage?
}

extension Contact : Identifiable {
}
