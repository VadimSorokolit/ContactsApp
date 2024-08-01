//
//  ContactModel.swift
//  ContactsApp
//
//  Created by Vadim Sorokolit on 31.07.2024.
//

import Foundation
import CoreData

struct ContactStruct {
    var fullName: String?
    var jobPosition: String?
    var email: String?
    var photo: Data?
    
    func asEntity(withContext context: NSManagedObjectContext) -> Contact {
        let contact = Contact(context: context)
        contact.fullName = self.fullName
        contact.jobPosition = self.jobPosition
        contact.email = self.email
        contact.photo = self.photo
        return contact
    }

}

