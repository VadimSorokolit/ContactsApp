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
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        let lhsFullName = lhs.fullName ?? ""
        let lhsJobPosition = lhs.jobPosition ?? ""
        let lhsEmail = lhs.email ?? ""
        let lhsPhoto = lhs.photo ?? Data()
        
        let rhsFullName = rhs.fullName ?? ""
        let rhsJobPosition = rhs.jobPosition ?? ""
        let rhsEmail = rhs.email ?? ""
        let rhsPhoto = rhs.photo ?? Data()
        
        let isEqual = lhsFullName == rhsFullName
                      && lhsJobPosition == rhsJobPosition
                      && lhsEmail == rhsEmail
                      && lhsPhoto == rhsPhoto
        
        return isEqual
    }
    
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

