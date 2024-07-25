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
    func fetchContacts() throws -> [Contact] {
        let fetchRequest = Contact.fetchRequest()
        
        do {
            let contacts = try self.context.fetch(fetchRequest)
            if !contacts.isEmpty {
                return contacts
            } else {
                print("Database is empty")
                return []
            }
        }
        catch {
            throw error
        }
    }
    
    // Search contacts by fullName and jobPosition
    func searchContacts(byFullName fullName: String?, jobPosition: String?) throws -> [Contact] {
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
            return []
        } else {
            let compoundPredicateType = NSCompoundPredicate.LogicalType.or
            let compoundPredicate = NSCompoundPredicate(type: compoundPredicateType, subpredicates: predicates)
            fetchRequest.predicate = compoundPredicate
            
            do {
                let foundContacts = try self.context.fetch(fetchRequest)
                return foundContacts
            } catch {
                throw error
            }
        }
    }

    // Fetch contact by email
    func fetchContact(byEmail email: String) throws -> Contact? {
        let fetchRequest = Contact.fetchRequest()
        let predicate = NSPredicate(format: "email == %@", email)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        do {
            let contacts = try self.context.fetch(fetchRequest)
            let contact = contacts.first
            return contact
        } catch {
            throw error
        }
    }
    
    // Create empty contact
    func createNewEmptyContact() -> Contact? {
        let newEmptyContact = Contact(context: self.context)
        return newEmptyContact
    }
    
    // Save contact
    func saveContact(contact: Contact) {
        self.persistentContainer.performBackgroundTask({ (context: NSManagedObjectContext)  in
            guard let contactEmail = contact.email else { return }
//            if try self.isContactExist(byEmail: contactEmail) {
//                return
//            }
            do {

                try  contact.managedObjectContext?.save()
                try context.save()
             
            } catch {
                
            }
        })
        

    }
    
    // Update contact
    func updateContact(editedContact: Contact, completion: @escaping (Result<Void, Error>) -> Void) {
        self.persistentContainer.performBackgroundTask({ (context: NSManagedObjectContext)  in
            guard let contactEmail = editedContact.email else { return }
            
            let fetchRequest = Contact.fetchRequest()
            let predicate = NSPredicate(format: "email = %@", contactEmail)
            fetchRequest.predicate = predicate
            fetchRequest.fetchLimit = 1
            
            do {
                let contacts = try context.fetch(fetchRequest)
                
                if let contact = contacts.first {
                    contact.fullName = editedContact.fullName
                    contact.jobPosition = editedContact.jobPosition
                    contact.photo = editedContact.photo
                }
                try context.save()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        })
    }
        
    // Delete all contacts
    func deleteAllContacts() throws {
        let fetchRequest = Contact.fetchRequest()
        
        do {
            let contacts = try self.context.fetch(fetchRequest)
            contacts.forEach({ (contact: Contact) -> Void in
                self.context.delete(contact)
            })
            try self.context.save()
        } catch {
            throw error
        }
    }
    
    // Delete contact by email
    func deleteContact(byEmail email: String) throws -> Contact? {
        let fetchRequest = Contact.fetchRequest()
        let predicate = NSPredicate(format: "email == %@", email)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        do {
            let contacts = try self.context.fetch(fetchRequest)
            if let contact = contacts.first {
                self.context.delete(contact)
                try self.context.save()
                return contact
            } else {
                print("Contact does not exist")
            }
        } catch {
            throw error
        }
        return nil
    }
    
    // Check contact by email
    func isContactExist(byEmail email: String) throws -> Bool {
        let fetchRequest = Contact.fetchRequest()
        let predicate = NSPredicate(format: "email == %@", email)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        do {
            let contacts = try self.context.fetch(fetchRequest)
            if !contacts.isEmpty {
                return true
            }
        } catch {
            throw error
        }
        return false
    }
    
}
