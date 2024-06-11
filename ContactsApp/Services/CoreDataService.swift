//
//  CoreDataService.swift
//  ContactsApp
//
//  Created by Vadym Sorokolit on 11.06.2024.
//

import Foundation
import UIKit
import CoreData

// MARK: - CRUD

public final class CoreDataManager: NSObject {
    private static let shared = CoreDataManager()
    
    private override init() {}
    
    private var appDelegate: AppDelegate {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not cast UIApplication.shared.delegate to AppDelegate")
        }
        return appDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    // Creat contact
    public func createContact(name: String, jobPosition: String, email: String, photo: UIImage?) {
        guard let contactEnityDesctription = NSEntityDescription.entity(forEntityName: "Contact", in: context) else {
            print("Error: Contact entity description not found")
            return
        }
        let contact = Contact(entity: contactEnityDesctription, insertInto: context)
        contact.name = name
        contact.jobPosition = jobPosition
        contact.email = email
        contact.photo = photo ?? UIImage(systemName: "photo")
        
        appDelegate.saveContext()
    }
    
    // Fetch contacts
    public func fetchContacts() -> [Contact] {
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
    
    
}
