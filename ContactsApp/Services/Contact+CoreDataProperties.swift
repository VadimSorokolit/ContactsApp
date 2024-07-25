//
//  Contact+CoreDataProperties.swift
//  ContactsApp
//
//  Created by Vadim Sorokolit on 12.06.2024.
//
//

import Foundation
import CoreData

extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var fullName: String?
    @NSManaged public var jobPosition: String?
    @NSManaged public var email: String?
    @NSManaged public var photo: Data?
    
    public func clone() -> Contact? {
        if let managedObjectContext = self.managedObjectContext{
            let newContact = Contact(context: managedObjectContext)
            newContact.fullName = self.fullName
            newContact.jobPosition = self.jobPosition
            newContact.email = self.email
            newContact.photo = self.photo
            return newContact
        } else {
            return nil
        }
    }

}

extension Contact : Identifiable {}


