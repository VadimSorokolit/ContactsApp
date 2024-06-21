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
    private let fetchRequest = Contact.fetchRequest()
    
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
        do {
            let contacts = try self.context.fetch(self.fetchRequest)
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
    
    // Fetch contact by email
    func fetchContact(byEmail email: String) throws -> Contact? {
        let predicate = NSPredicate(format: "email == %@", email)
        self.fetchRequest.predicate = predicate
        self.fetchRequest.fetchLimit = 1
        do {
            let contacts = try self.context.fetch(self.fetchRequest)
            let contact = contacts.first
            return contact
        } catch {
            throw error
        }
    }
    
    // Create contact
    func createContact(fullName: String, jobPosition: String, email: String, photo: UIImage?) throws -> Contact? {
        if try self.isContactExist(byEmail: email) {
            return nil
        }
        let contact = Contact(context: self.context)
        contact.fullName = fullName
        contact.jobPosition = jobPosition
        contact.email = email
        contact.photo = photo
        do {
            try self.context.save()
            return contact
        } catch {
            throw error
        }
    }
    
    // Update contact
    func updateContact(byEmail email: String, jobPosition: String) throws -> Contact? {
        let predicate = NSPredicate(format: "email == %@", email)
        self.fetchRequest.predicate = predicate
        self.fetchRequest.fetchLimit = 1
        do {
            let contacts = try self.context.fetch(self.fetchRequest)
            if let contact = contacts.first {
                contact.jobPosition = jobPosition
                try self.context.save()
                return contact
            }
        } catch {
            throw error
        }
        return nil
    }
    
    // Delete all contacts
    func deleteAllContacts() throws {
        do {
            let contacts = try self.context.fetch(self.fetchRequest)
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
        let predicate = NSPredicate(format: "email == %@", email)
        self.fetchRequest.predicate = predicate
        self.fetchRequest.fetchLimit = 1
        do {
            let contacts = try self.context.fetch(self.fetchRequest)
            if let contact = contacts.first {
                self.context.delete(contact)
                try context.save()
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
        let predicate = NSPredicate(format: "email == %@", email)
        self.fetchRequest.predicate = predicate
        self.fetchRequest.fetchLimit = 1
        do {
            let contacts = try self.context.fetch(self.fetchRequest)
            if !contacts.isEmpty {
                return true
            }
        } catch {
            throw error
        }
        return false
    }
    
}
