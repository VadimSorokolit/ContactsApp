//
//  ContactsViewModel.swift
//  ContactsApp
//
//  Created by Vadym Sorokolit on 20.06.2024.
//

import Foundation
import UIKit

class ContactsViewModel {
    
    // MARK: - Properties
    
    private let coreDataService = CoreDataService()
    
    // MARK: - Methods
    
    private func fetchContacts() -> [Contact] {
        do {
            let contacts = try self.coreDataService.fetchContacts()
            notify(name: .contactsFetchedNotification)
            return contacts
        } catch {
            notifyError(error: error.localizedDescription)
            return []
        }
    }
    
    private func fetchContact(byEmail email: String) -> Contact? {
        do {
            let contact = try self.coreDataService.fetchContact(byEmail: email)
            if contact != nil {
                notify(name: .contactFetchedNotification)
            }
            return contact
        } catch {
            notifyError(error: error.localizedDescription)
            return nil
        }
    }
    
    private func createContact(fullName: String, jobPosition: String, email: String, photo: UIImage?) {
        do {
            try self.coreDataService.updateContact(byEmail: email, jobPosition: jobPosition)
            notify(name: .contactUpdatedNotification)
        } catch {
            notifyError(error: error.localizedDescription)
        }
    }

    private func deleteContact(byEmail email: String) {
        do {
            try self.coreDataService.deleteContact(byEmail: email)
            notify(name: .contactDeletedNotification)
        } catch {
            notifyError(error: error.localizedDescription)
        }
    }
    
    private func notify(name: Notification.Name) {
        NotificationCenter.default.post(name: name, object: nil)
    }
    
    private func notifyError(error: String) {
        NotificationCenter.default.post(name: .errorNotification, object: error)
    }

}

extension Notification.Name {
    
    static let contactsFetchedNotification = Notification.Name("contactsFetchedNotification")
    static let contactFetchedNotification = Notification.Name("contactFetchedNotification")
    static let contactCreatedNotification = Notification.Name("contactCreatedNotification")
    static let contactUpdatedNotification = Notification.Name("contactUpdatedNotification")
    static let contactDeletedNotification = Notification.Name("contactDeletedNotification")
    static let errorNotification = Notification.Name("errorNotification")
    
}


