//
//  CoreDataService.swift
//  ContactsApp
//
//  Created by Vadim Sorokolit on 12.06.2024.
//

import Foundation
import UIKit
import CoreData

class CoreDataService {
    
    // MARK: - Objects
    
    private struct Constants {
        static let errorContactUpdate: String = "Contact doesn't update"
        static let errorContactDoesntExist: String = "Contact doesn't exist"
    }
    
    // MARK: - Properties
    
    private var persistentContainer: NSPersistentContainer!
    private var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    // MARK: - Initializers
    
    init() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.persistentContainer = appDelegate?.persistentContainer
    }
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    // MARK: - Methods
    
    // Fetch contacts
    func fetchContacts(completion: @escaping (Result<[ContactEntity], Error>) -> Void) {
        self.persistentContainer.performBackgroundTask({ (context: NSManagedObjectContext) -> Void in
            let fetchRequest: NSFetchRequest<ContactEntity> = ContactEntity.fetchRequest()
            
            do {
                let contacts = try context.fetch(fetchRequest)
                completion(.success(contacts))
            } catch {
                completion(.failure(error))
            }
        })
    }
    
    // Search contacts by fullName and jobPosition
    func searchContacts(byFullName fullName: String?, jobPosition: String?, completion: @escaping (Result<[ContactEntity], Error>) -> Void) {
        self.persistentContainer.performBackgroundTask({ (context: NSManagedObjectContext) -> Void in
            let fetchRequest = ContactEntity.fetchRequest()
            var predicates: [NSPredicate] = []
            
            if let fullName = fullName, !fullName.isEmpty {
                let trimmedFullName = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
                let fullNamePredicate = NSPredicate(format: "fullName CONTAINS[c] %@", trimmedFullName)
                predicates.append(fullNamePredicate)
            }
            
            if let jobPosition = jobPosition, !jobPosition.isEmpty {
                let trimmedJobPosition = jobPosition.trimmingCharacters(in: .whitespacesAndNewlines)
                let jobPositionPredicate = NSPredicate(format: "jobPosition CONTAINS[c] %@", trimmedJobPosition)
                predicates.append(jobPositionPredicate)
            }
            
            if predicates.isEmpty {
                completion(.success([]))
            } else {
                let compoundPredicateType = NSCompoundPredicate.LogicalType.or
                let compoundPredicate = NSCompoundPredicate(type: compoundPredicateType, subpredicates: predicates)
                fetchRequest.predicate = compoundPredicate
                
                do {
                    let foundContacts = try context.fetch(fetchRequest)
                    completion(.success(foundContacts))
                } catch {
                    completion(.failure(error))
                }
            }
        })
    }
    
    // Fetch contact by email
    func fetchContact(byEmail email: String, completion: @escaping (Result<ContactEntity?, Error>) -> Void) {
        self.persistentContainer.performBackgroundTask({ (context: NSManagedObjectContext) -> Void in
            let fetchRequest = ContactEntity.fetchRequest()
            let predicate = NSPredicate(format: "email == %@", email)
            fetchRequest.predicate = predicate
            fetchRequest.fetchLimit = 1
            
            do {
                let contacts = try context.fetch(fetchRequest)
                let contact = contacts.first
                completion(.success(contact))
            } catch {
                completion(.failure(error))
            }
        })
    }
    
    // Save contact
    func saveContact(contact: ContactStruct, completion: @escaping (Result<Void, Error>) -> Void) {
        self.persistentContainer.performBackgroundTask({ (context: NSManagedObjectContext) -> Void in
            
            do {
                _ = contact.asEntity(withContext: context)
                try context.save()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        })
    }

    // Update contact
    func updateContact(editedContact: ContactStruct, completion: @escaping (Result<Void, Error>) -> Void) {
        self.persistentContainer.performBackgroundTask({ (context: NSManagedObjectContext) -> Void in
            let fetchRequest: NSFetchRequest<ContactEntity> = ContactEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "email == %@", editedContact.email ?? "")
            
            do {
                let contacts = try context.fetch(fetchRequest)
                
                if let existingContact = contacts.first {
                    existingContact.fullName = editedContact.fullName
                    existingContact.jobPosition = editedContact.jobPosition
                    existingContact.email = editedContact.email
                    existingContact.photo = editedContact.photo
                    
                    try context.save()
                    
                } else {
                    let error = NSError(domain: Constants.errorContactUpdate, code: 1)
                    completion(.failure(error))
                }
            } catch {
                completion(.failure(error))
            }
        })
    }
    
    // Delete all contacts
    func deleteAllContacts(completion: @escaping (Result<Void,Error>) -> Void)  {
        self.persistentContainer.performBackgroundTask({ (context: NSManagedObjectContext) -> Void in
            let fetchRequest = ContactEntity.fetchRequest()
            
            do {
                let contacts = try context.fetch(fetchRequest)
                contacts.forEach({ (contact: ContactEntity) -> Void in
                    context.delete(contact)
                })
                try context.save()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        })
    }
    
    // Delete contact by email
    func deleteContact(byEmail email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        self.persistentContainer.performBackgroundTask({ (context: NSManagedObjectContext) -> Void in
            let fetchRequest: NSFetchRequest<ContactEntity> = ContactEntity.fetchRequest()
            let predicate = NSPredicate(format: "email == %@", email)
            fetchRequest.predicate = predicate
            fetchRequest.fetchLimit = 1
            
            do {
                let contacts = try context.fetch(fetchRequest)
                if let contact = contacts.first {
                    context.delete(contact)
                    try context.save()
                    completion(.success(()))
                } else {
                    let error = NSError(domain: Constants.errorContactDoesntExist, code: 1)
                    completion(.failure(error))
                }
            } catch {
                completion(.failure(error))
            }
        })
    }
    
    // Check contact by email
    func isContactExist(byEmail email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        self.persistentContainer.performBackgroundTask({ (context: NSManagedObjectContext) -> Void in
            let fetchRequest: NSFetchRequest<ContactEntity> = ContactEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "email == %@", email)
            fetchRequest.fetchLimit = 1
            
            do {
                let contacts = try context.fetch(fetchRequest)
                completion(.success(!contacts.isEmpty))
            } catch {
                completion(.failure(error))
            }
        })
    }
    
}

