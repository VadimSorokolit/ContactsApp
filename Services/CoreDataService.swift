//
//  CoreDataService.swift
//  ContactsApp
//
//  Created by Vadym Sorokolit on 12.06.2024.
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
    
    init(persistentContainer: NSPersistentContainer!) {
        self.persistentContainer = persistentContainer
    }
    
    // MARK: - Methods
    
    // Fetch contacts
    func fetchContacts() -> [Contact] {
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
            print("Error fetching contacts: \(error.localizedDescription)")
            return []
        }
    }
    
    // Fetch contact by email
    func fetchContact(byEmail email: String) -> Contact? {
        let predicate = NSPredicate(format: "email == %@", email)
        self.fetchRequest.predicate = predicate
        self.fetchRequest.fetchLimit = 1
        do {
            let contacts = try self.context.fetch(self.fetchRequest)
            let contact = contacts.first
            return contact
        } catch {
            print("Error fetching contact by email: \(error.localizedDescription)")
            return nil
        }
    }
    
    // Create contact
    func createContact(fullName: String, jobPosition: String, email: String, photo: UIImage?) {
        if self.isContactExist(byEmail: email) {
            return
        }
        let contact = Contact(context: self.context)
        contact.fullName = fullName
        contact.jobPosition = jobPosition
        contact.email = email
        contact.photo = photo
        do {
            try self.context.save()
        } catch {
            print("Failed to save the contact: \(error.localizedDescription)")
        }
    }
    
    // Update contact
    func updateContact(byEmail email: String, jobPosition: String) {
        let predicate = NSPredicate(format: "email == %@", email)
        self.fetchRequest.predicate = predicate
        self.fetchRequest.fetchLimit = 1
        do {
            let contacts = try self.self.context.fetch(self.fetchRequest)
            if let contact = contacts.first {
                contact.jobPosition = jobPosition
                try self.context.save()
            }
        } catch {
            print("Error fetching or updating contact: \(error.localizedDescription)")
        }
    }
    
    // Delete all contacts
    func deleteAllContacts() {
        do {
            let contacts = try self.self.context.fetch(self.fetchRequest)
            contacts.forEach({ (contact: Contact) -> Void in
                self.self.context.delete(contact)
            })
            try self.context.save()
        } catch {
            print("Error fetching contacts: \(error.localizedDescription)")
        }
    }
    
    // Delete contact by email
    func deleteContact(byEmail email: String) {
        let predicate = NSPredicate(format: "email == %@", email)
        self.fetchRequest.predicate = predicate
        self.fetchRequest.fetchLimit = 1
        do {
            let contacts = try self.context.fetch(self.fetchRequest)
            if let contact = contacts.first {
                self.context.delete(contact)
                try context.save()
            } else {
                print("Contact does not exist")
            }
        } catch {
            print("Error fetching or deleting contact: \(error.localizedDescription)")
        }
    }
    
    // Check contact by email
    func isContactExist(byEmail email: String) -> Bool {
        let predicate = NSPredicate(format: "email == %@", email)
        self.fetchRequest.predicate = predicate
        self.fetchRequest.fetchLimit = 1
        do {
            let contacts = try self.context.fetch(self.fetchRequest)
            if !contacts.isEmpty {
                return true
            }
        } catch {
            print("Error fetching contact by email: \(error.localizedDescription)")
        }
        return false
    }
    
}
