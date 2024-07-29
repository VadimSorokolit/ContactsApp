//
//  ContactsViewModel.swift
//  ContactsApp
//
//  Created by Vadim Sorokolit on 20.06.2024.
//

import Foundation
import UIKit
import CoreData

class ContactsViewModel {
    
    // MARK: - Properties
    
    private let coreDataService: CoreDataService = CoreDataService()
    var contacts: [Contact] = []
    
    // MARK: - Methods
    
//    func fetchContacts() {
//        do {
//            let contacts = try self.coreDataService.fetchContacts()
//            self.contacts = contacts
//            print(contacts.map({ contact in
//                contact.email
//            }))
//            self.notify(name: .contactsFetchedNotification)
//        } catch {
//            self.notify(name: .errorNotification, error: error.localizedDescription)
//        }
//    }
    
//    func searchContacts(byQuery query: String) {
//        do {
//            let foundContacts = try self.coreDataService.searchContacts(byFullName: query, jobPosition: query)
//            self.contacts = foundContacts
//            self.notify(name: .contactsFoundNotification)
//        } catch {
//            self.notify(name: .errorNotification, error: error.localizedDescription)
//        }
//    }
    
//    func createNewEmptyContact() -> Contact? {
//        let contact = self.coreDataService.createNewEmptyContact()
//        return contact
//    }

//    func createContact(fullName: String, jobPosition: String, email: String, photo: Data?) {
//        do {
//            if let contact = try self.coreDataService.createContact(fullName: fullName, jobPosition: jobPosition, email: email, photo: photo) {
//                self.contacts.append(contact)
//                self.notify(name: .contactCreatedNotification)
//            }
//        } catch {
//            self.notify(name: .errorNotification, error: error.localizedDescription)
//        }
//    }
    
    // !!!! Only for test create contacts
//    func testCreateContacts() {
//        self.createContact(fullName: "Vadim Sorokolit", jobPosition: "iOS Developer", email: "macintosh@ukr.net", photo: nil)
//        self.createContact(fullName: "Viktor Shtoyko", jobPosition: "Driver", email: "kotik@ukr.net", photo: nil)
//        let image = UIImage(named: "splashScreenImage")
//        self.createContact(fullName: "Marina Nazarenko", jobPosition: "Teacher", email: "everest@i.ua", photo: nil)
//    }
    
    // !!!! Only for test delete all contacts
//    func deleteAllContacts() {
//        do {
//            try self.coreDataService.deleteAllContacts()
//            self.contacts.removeAll()
//            self.notify(name: .contactDeletedNotification)
//        } catch {
//            self.notify(name: .errorNotification, error: error.localizedDescription)
//        }
//    }
    
    func updateContact(contact: Contact) {
        self.coreDataService.updateContact(editedContact: contact, completion: { (result: Result<Void, Error>) -> Void in
            // switch result {case}
        })
        
//        do {
//            if let updatedContact = try self.coreDataService.updateContact(editedContact: contact) {
//                if let index = self.contacts.firstIndex(where: { $0.email == contact.email }) {
////                    self.contacts[index] = updatedContact
//                    self.notify(name: .contactUpdatedNotification)
//                }
//            }
//        } catch {
//            self.notify(name: .errorNotification, error: error.localizedDescription)
//        }
    }

//    func deleteContact(byEmail email: String) {
//        do {
//            if let contact = try self.self.coreDataService.deleteContact(byEmail: email) {
//                if let index = self.contacts.firstIndex(of: contact) {
//                    self.contacts.remove(at: index)
//                    self.notify(name: .contactDeletedNotification)
//                }
//            }
//        } catch {
//            self.notify(name: .errorNotification, error: error.localizedDescription)
//        }
//    }
    
    private func notify(name: Notification.Name, error: String? = nil) {
        var userInfo: [String: String]? = nil
        if let error = error {
            userInfo = ["error": error]
        }
        NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
    }
    
}




