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
    
    public func createContact(name: String, jobPosition: String, email: String, photo: UIImage) {
        
    }
}
