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
    
    func fetchContacts() -> [Contact] {
        let contacts = self.coreDataService.fetchContacts()
        NotificationCenter.default.post(name: .contactsFetchedNotification, object: nil)
        return contacts
    }
    
    func fetchContact(byEmail email: String) -> Contact? {
        let contact = self.coreDataService.fetchContact(byEmail: email)
        if contact != nil {
            NotificationCenter.default.post(name: .contactFetchedNotification, object: nil)
        }
        return contact
    }
    
    private func createContact(fullName: String, jobPosition: String, email: String, photo: UIImage?) {
        self.coreDataService.createContact(fullName: fullName, jobPosition: jobPosition, email: email, photo: photo)
        NotificationCenter.default.post(name: .contactCreatedNotification, object: nil)
    }
    
    private func updateContact(byEmail email: String, jobPostion: String) {
        self.coreDataService.updateContact(byEmail: email, jobPosition: jobPostion)
        NotificationCenter.default.post(name: .contactUpdatedNotification, object: nil)
    }
    
    private func deleteContact(byEmail email: String) {
        self.coreDataService.deleteContact(byEmail: email)
        NotificationCenter.default.post(name: .contactDeletedNotification, object: nil)
    }
    
}

extension Notification.Name {
    
    static let contactsFetchedNotification = Notification.Name("contactsFetchedNotification")
    static let contactFetchedNotification = Notification.Name("contactFetchedNotification")
    static let contactCreatedNotification = Notification.Name("contactCreatedNotification")
    static let contactUpdatedNotification = Notification.Name("contactUpdatedNotification")
    static let contactDeletedNotification = Notification.Name("contactDeletedNotification")
    
}


