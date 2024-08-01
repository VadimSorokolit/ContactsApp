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
        static let errorInvalidContact: String = "Invalid Contact"
        static let errorIsContactExist: String  = "Contact is exist"
        static let errorContactDoesntExist: String = "Contact doesn't exist"
        static let errorContactEmailDoesntExist: String = "Contact email doesn't exist"
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
    func fetchContacts(completion: @escaping (Result<[Contact], Error>) -> Void) {
        print(#function)
        self.persistentContainer.performBackgroundTask({ (context: NSManagedObjectContext) -> Void in
            let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
            
            do {
                let contacts = try context.fetch(fetchRequest)
                completion(.success(contacts))
            } catch {
                completion(.failure(error))
            }
        })
    }
    
    // Search contacts by fullName and jobPosition
    func searchContacts(byFullName fullName: String?, jobPosition: String?, completion: @escaping (Result<[Contact], Error>) -> Void) {
        self.persistentContainer.performBackgroundTask({ (context: NSManagedObjectContext) -> Void in
            let fetchRequest = Contact.fetchRequest()
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
    func fetchContact(byEmail email: String, completion: @escaping (Result<Contact?, Error>) -> Void) {
        self.persistentContainer.performBackgroundTask({ (context: NSManagedObjectContext) -> Void in
            let fetchRequest = Contact.fetchRequest()
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
    
    // Create empty contact
    func createEmptyContact() -> Contact {
        let newEmptyContact = Contact(context: self.context)
        return newEmptyContact
    }

    // Save contact
    func saveContact(contact: ContactStruct, completion: @escaping (Result<Void, Error>) -> Void) {
        self.persistentContainer.performBackgroundTask { (context: NSManagedObjectContext) in
            
            let newContact = Contact(context: context)
            newContact.fullName = contact.fullName
            newContact.jobPosition = contact.jobPosition
            newContact.email = contact.email
            newContact.photo = contact.photo
            
            do {
                try context.save()
                print("Contact saved successfully")
                completion(.success(()))
            } catch {
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }

    // Update contact
    func updateContact(editedContact: ContactStruct, completion: @escaping (Result<Void, Error>) -> Void) {
        self.persistentContainer.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "email == %@", editedContact.email ?? "")
            
            do {
                let contacts = try context.fetch(fetchRequest)
                
                if let existingContact = contacts.first {
                    existingContact.fullName = editedContact.fullName
                    existingContact.jobPosition = editedContact.jobPosition
                    existingContact.photo = editedContact.photo
                    
                    try context.save()
                    print("Contact updated successfully")
                    
                    self.fetchContacts { fetchResult in
                        switch fetchResult {
                            case .success:
                                completion(.success(()))
                            case .failure(let error):
                                print(error.localizedDescription)
                                completion(.failure(error))
                        }
                    }
                } else {
                    let error = NSError(domain: "ContactUpdateErrorDomain", code: 1)
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            } catch {
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    // Delete all contacts
    func deleteAllContacts(completion: @escaping (Result<Void,Error>) -> Void)  {
        self.persistentContainer.performBackgroundTask({ (context: NSManagedObjectContext) -> Void in
            let fetchRequest = Contact.fetchRequest()
            
            do {
                let contacts = try context.fetch(fetchRequest)
                contacts.forEach({ (contact: Contact) -> Void in
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
            let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
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
        self.persistentContainer.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "email == %@", email)
            fetchRequest.fetchLimit = 1
            
            do {
                let contacts = try context.fetch(fetchRequest)
                completion(.success(!contacts.isEmpty))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
}

