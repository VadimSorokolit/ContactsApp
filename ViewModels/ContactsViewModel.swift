//
//  ContactsViewModel.swift
//  ContactsApp
//
//  Created by Vadim Sorokolit on 20.06.2024.
//

import Foundation
import UIKit

class ContactsViewModel {
    
    // MARK: - Properties
    
    private let coreDataService: CoreDataService = CoreDataService()
    private var contacts: [Contact] = []
    
    // MARK: - Methods
    
    private func fetchContacts() {
        do {
            let contacts = try self.coreDataService.fetchContacts()
            self.contacts = contacts
            self.notify(name: .contactsFetchedNotification)
        } catch {
            self.notify(name: .errorNotification, error: error.localizedDescription)
        }
    }
    
    private func updateContact(byEmail email: String, jobPosition: String) {
        do {
            if let updatedContact = try coreDataService.fetchContact(byEmail: email) {
                if let index = contacts.firstIndex(where: { $0.email == email }) {
                    self.contacts[index] = updatedContact
                }
            }
        } catch {
            self.notify(name: .errorNotification, error: error.localizedDescription)
        }
    }
    
    private func createContact(fullName: String, jobPosition: String, email: String, photo: UIImage?) {
        do {
            if let contact = try coreDataService.createContact(fullName: fullName, jobPosition: jobPosition, email: email, photo: photo) {
                self.contacts.append(contact)
                notify(name: .contactCreatedNotification)
            }
        } catch {
            self.notify(name: .errorNotification, error: error.localizedDescription)
        }
    }

    private func deleteContact(byEmail email: String) {
        do {
            if let contact = try self.coreDataService.deleteContact(byEmail: email) {
                if let index = self.contacts.firstIndex(of: contact) {
                    self.contacts.remove(at: index)
                }
                self.notify(name: .contactDeletedNotification)
            }
        } catch {
            self.notify(name: .errorNotification, error: error.localizedDescription)
        }
    }
    
    private func notify(name: Notification.Name, error: String? = nil) {
        NotificationCenter.default.post(name: name, object: nil)
    }
    
}




