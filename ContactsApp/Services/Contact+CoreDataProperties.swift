//
//  ContactEntity+CoreDataProperties.swift
//  ContactsApp
//
//  Created by Vadim Sorokolit on 12.06.2024.
//
//

import Foundation
import CoreData

extension ContactEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactEntity> {
        return NSFetchRequest<ContactEntity>(entityName: "ContactEntity")
    }

    @NSManaged public var fullName: String?
    @NSManaged public var jobPosition: String?
    @NSManaged public var email: String?
    @NSManaged public var photo: Data?
    
    // ContactEntity -> ContactStruct
    func asStruct() -> ContactStruct {
        var newContact = ContactStruct()
        newContact.fullName = self.fullName
        newContact.jobPosition = self.jobPosition
        newContact.email = self.email
        newContact.photo = self.photo
        return newContact
    }

}

extension ContactEntity : Identifiable {}


