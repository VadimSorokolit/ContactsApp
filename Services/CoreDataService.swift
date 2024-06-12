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
    
    // MARK: - Methods
    
    private init() {}
    
    // Create contact
    func createContact(name: String, jobPosition: String, email: String, photo: UIImage?) {
        guard let contactEnityDesctription = NSEntityDescription.entity(forEntityName: "Contact", in: context) else {
            print("Error: Contact entity description not found")
            return
        }
        let contact = Contact(entity: contactEnityDesctription, insertInto: context)
        contact.name = name
        contact.jobPosition = jobPosition
        contact.email = email
        contact.photo = photo ?? UIImage(systemName: "photo")
        
        self.appDelegate.saveContext()
    }
    
    // Fetch contacts
    func fetchContacts() -> [Contact] {
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        do {
            if let contacts = try context.fetch(fetchRequest) as? [Contact] {
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
    func fetchContact(_ email: String) -> Contact? {
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        do {
            if let contacts = try context.fetch(fetchRequest) as? [Contact] {
                return contacts.first(where: { $0.email == email })
            }
        } catch {
            print("Error fetching contacts: \(error.localizedDescription)")
        }
        return nil
    }
    
    // Update contact
    func updateContact(by email: String, jobPosition: String) {
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        do {
            if let contacts = try context.fetch(fetchRequest) as? [Contact] {
                let contact = contacts.first(where: { $0.email == email })
                contact?.jobPosition = jobPosition
            }
            self.appDelegate.saveContext()
        } catch {
            print("Error fetching contacts: \(error.localizedDescription)")
        }
    }
    
    // Delete all contacts
    func deleteContacts() {
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        do {
            if let contacts = try context.fetch(fetchRequest) as? [Contact] {
                contacts.forEach { context.delete($0) }
            }
            self.appDelegate.saveContext()
        } catch {
            print("Error fetching contacts: \(error.localizedDescription)")
        }
    }
    
    // Delete contact by email
    func deleteContact(by email: String) {
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        do {
            if let contacts = try context.fetch(fetchRequest) as? [Contact] {
                if let contact = contacts.first(where: { $0.email == email }) {
                    context.delete(contact)
                } else {
                    print("It's contact don't exist")
                }
            }
            self.appDelegate.saveContext()
        }
        catch {
            print("Error fetching contacts: \(error.localizedDescription)")
        }
    }
    
}
