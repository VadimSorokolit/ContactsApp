//
//  ContactStruct.swift
//  ContactsApp
//
//  Created by Vadim Sorokolit on 31.07.2024.
//

import Foundation
import CoreData

struct ContactStruct: Equatable {
    var fullName: String?
    var jobPosition: String?
    var email: String?
    var photo: Data?
    
    // ContactStruct -> ContactEntity
    func asEntity(withContext context: NSManagedObjectContext) -> ContactEntity {
        let contact = ContactEntity(context: context)
        contact.fullName = self.fullName
        contact.jobPosition = self.jobPosition
        contact.email = self.email
        contact.photo = self.photo
        return contact
    }

}

