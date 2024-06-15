//
//  CoreDataService.swift
//  ContactsApp
//
//  Created by Vadym Sorokolit on 12.06.2024.
//

import Foundation
import UIKit
import CoreData

final class CoreDataService {
    
    // MARK: - Properties
    
    static let shared = CoreDataService()
    
    private var appDelegate: AppDelegate {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not cast UIApplication.shared.delegate to AppDelegate")
        }
        return appDelegate
    }
    
    private var context: NSManagedObjectContext {
        self.appDelegate.persistentContainer.viewContext
    }
    
    private let fetchRequest = Contact.fetchRequest()
    
    // MARK: - Methods
    
    private init() {}
    
    // Create contact
    func createContact(fullName: String, jobPosition: String, email: String, photo: UIImage?) {
        if self.isContactExist(by: email) {
            return
        }
        let contact = Contact(context: self.context)
        contact.fullName = fullName
        contact.jobPosition = jobPosition
        contact.email = email
        contact.photo = photo
        self.appDelegate.saveContext()
    }
    
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
    func fetchContact(by email: String) -> Contact? {
        self.fetchRequest.predicate = NSPredicate(format: "email == %@", email)
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
    
    // Update contact
    func updateContact(by email: String, jobPosition: String) {
        let predicate = NSPredicate(format: "email == %@", email)
        self.fetchRequest.predicate = predicate
        self.fetchRequest.fetchLimit = 1
        do {
            let contacts = try self.context.fetch(self.fetchRequest)
            if let contact = contacts.first {
                contact.jobPosition = jobPosition
                self.appDelegate.saveContext()
            }
        } catch {
            print("Error fetching or updating contact: \(error.localizedDescription)")
        }
    }
    
    // Delete all contacts
    func deleteAllContacts() {
        do {
            let contacts = try self.context.fetch(self.fetchRequest)
            contacts.forEach({ contact in
                self.context.delete(contact)
            })
            self.appDelegate.saveContext()
        } catch {
            print("Error fetching contacts: \(error.localizedDescription)")
        }
    }
    
    // Delete contact by email
    func deleteContact(by email: String) {
        let predicate = NSPredicate(format: "email == %@", email)
        self.fetchRequest.predicate = predicate
        self.fetchRequest.fetchLimit = 1
        do {
            let contacts = try self.context.fetch(self.fetchRequest)
            if let contact = contacts.first {
                self.context.delete(contact)
                self.appDelegate.saveContext()
            } else {
                print("Contact does not exist")
            }
        } catch {
            print("Error fetching or deleting contact: \(error.localizedDescription)")
        }
    }
    
    // Check contact by email
    func isContactExist(by email: String) -> Bool {
        self.fetchRequest.predicate = NSPredicate(format: "email == %@", email)
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
