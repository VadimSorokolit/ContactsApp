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
    
    private let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
    
    // MARK: - Methods
    
    private init() {}
    
    // Create contact
    func createContact(fullName: String, jobPosition: String, email: String, photo: UIImage?) {
        if self.isContactExist(by: email) {
            return
        }
        guard let contactEnityDesctription = NSEntityDescription.entity(forEntityName: "Contact", in: self.context) else {
            print("Error: Contact entity description not found")
            return
        }
        let contact = Contact(entity: contactEnityDesctription, insertInto: self.context)
        contact.fullName = fullName
        contact.jobPosition = jobPosition
        contact.email = email
        contact.photo = photo 
        self.appDelegate.saveContext()
    }
    
    // Fetch contacts
    func fetchContacts() -> [Contact] {
        do {
            if let contacts = try self.context.fetch(self.fetchRequest) as? [Contact] {
                return contacts
            } else {
                print("Error: Could not cast fetched objects to [Contact]")
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
            let contacts = try context.fetch(self.fetchRequest)
            return contacts.first as? Contact
        } catch {
            print("Error fetching contact by email: \(error.localizedDescription)")
            return nil
        }
    }
    
    // Update contact
    func updateContact(by email: String, jobPosition: String) {
        // Create a predicate to filter by email
        let predicate = NSPredicate(format: "email == %@", email)
        self.fetchRequest.predicate = predicate
        // Set fetch limit to 1
        self.fetchRequest.fetchLimit = 1
        do {
            if let contacts = try self.context.fetch(self.fetchRequest) as? [Contact], let contact = contacts.first {
                // Update the job position
                contact.jobPosition = jobPosition
                // Save the context
                self.appDelegate.saveContext()
            }
        } catch {
            print("Error fetching or updating contact: \(error.localizedDescription)")
        }
    }
    
    // Delete all contacts
    func deleteAllContacts() {
        do {
            if let contacts = try self.context.fetch(self.fetchRequest) as? [Contact] {
                contacts.forEach { self.context.delete($0) }
            }
            self.appDelegate.saveContext()
        } catch {
            print("Error fetching contacts: \(error.localizedDescription)")
        }
    }
    
    // Delete contact by email
    func deleteContact(by email: String) {
        // Create a predicate to filter by email
        let predicate = NSPredicate(format: "email == %@", email)
        self.fetchRequest.predicate = predicate
        // Set fetch limit to 1
        self.fetchRequest.fetchLimit = 1
        do {
            if let contacts = try self.context.fetch(self.fetchRequest) as? [Contact], let contact = contacts.first {
                // Delete the found contact
                self.context.delete(contact)
                // Save the context
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
            let contacts = try context.fetch(self.fetchRequest)
            if contacts.isEmpty {
                return false
            }
        } catch {
            print("Error fetching contact by email: \(error.localizedDescription)")
        }
        return true
    }
    
}
