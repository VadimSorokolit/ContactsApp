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
    
    let coreDataService: CoreDataService = CoreDataService()
    var contacts: [Contact] = []
    
    // MARK: - Methods
    
    func fetchContacts(completion: @escaping () -> Void) {
        self.coreDataService.fetchContacts { (fetchContactResult: Result<[Contact], Error>) -> Void in
            switch fetchContactResult {
            case .success(let contacts):
                DispatchQueue.main.async {
                    self.contacts = contacts
                    print("Fetched contacts: \(contacts.map({ contact in contact.email }))")
                    self.notify(name: .contactsFetchedNotification)
                    completion()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.notify(name: .errorNotification, error: error.localizedDescription)
                    completion()
                }
            }
        }
    }

    func searchContacts(byQuery query: String) {
        self.coreDataService.searchContacts(byFullName: query, jobPosition: query, completion: { (searchResult: Result<[Contact], Error>) -> Void in
            switch searchResult {
                case .success(let foundContacts):
                    self.contacts = foundContacts
                    self.notify(name: .contactsFoundNotification)
                case .failure(let error):
                    self.notify(name: .errorNotification, error: error.localizedDescription)
            }
        })
    }
    
    func createNewEmptyContact() -> Contact {
        let contact = self.coreDataService.createEmptyContact()
        return contact
    }

    // !!!! Only for test create contacts
    func testCreateContacts() {
        let contact1 = self.coreDataService.createEmptyContact()
        let contact2 = self.coreDataService.createEmptyContact()
        let contact3 = self.coreDataService.createEmptyContact()
        
        contact1.fullName = "Vadim Sorokolit"
        contact1.jobPosition = "iOS Developer"
        contact1.email = "macintosh@ukr.net"
        contact1.photo = nil
        
        contact2.fullName = "Viktor Shtoyko"
        contact2.jobPosition = "Driver"
        contact2.email = "kotik@ukr.net"
        contact2.photo = nil
        
        let image = UIImage(named: "splashScreenImage")?.pngData()
        contact3.fullName = "Marina Nazarenko"
        contact3.jobPosition = "Teacher"
        contact3.email = "everest@i.ua"
        contact3.photo = image
        self.coreDataService.saveContact(contact: contact1, completion: { (saveResult: Result<Void, Error>) -> Void in
            switch saveResult {
                case .success(()):
                    self.contacts.append(contact1)
                    self.coreDataService.saveContact(contact: contact2, completion: { (saveResult: Result<Void, Error>) -> Void in
                        switch saveResult {
                            case.success(()):
                                self.contacts.append(contact2)
                                self.coreDataService.saveContact(contact: contact3, completion: { (saveResult: Result<Void, Error>) -> Void in
                                    switch saveResult {
                                        case .success(()):
                                            self.contacts.append(contact3)
                                            print("All contacts saved")
                                        case .failure(let error):
                                            print(error.localizedDescription)
                                    }
                                })
                            case .failure(let error):
                                print(error.localizedDescription)
                        }
                    })
                case.failure(let error):
                    print(error.localizedDescription)
            }
        })
    }
     
    // !!!! Only for test delete all contacts
    func deleteAllContacts() {
        self.coreDataService.deleteAllContacts(completion: { (deleteResult: Result<Void, Error>) -> Void in
            switch deleteResult {
                case .success(()):
                    self.contacts.removeAll()
                case .failure(let error):
                    print(error.localizedDescription)
            }
        })
    }
    
    func updateContact(contact: Contact) {
        self.coreDataService.updateContact(editedContact: contact, completion: { (updateResult: Result<Void, Error>) -> Void in
            switch updateResult {
                case .success(()):
                    if let index = self.contacts.firstIndex(where: { $0.email == contact.email }) {
                        self.contacts[index] = contact
                        self.notify(name: .contactUpdatedNotification)
                    }
                case .failure(let error):
                    self.notify(name: .errorNotification, error: error.localizedDescription)
            }
        })
    }
        
    func deleteContact(byEmail email: String) {
        self.coreDataService.deleteContact(byEmail: email, completion: { (deleteResult: Result<Void, Error>) -> Void in
            switch deleteResult {
                case .success(()):
                    self.contacts = self.contacts.filter { $0.email != email }
                case .failure(let error):
                    self.notify(name: .errorNotification, error: error.localizedDescription)
            }
        })
    }

    private func notify(name: Notification.Name, error: String? = nil) {
        var userInfo: [String: String]? = nil
        if let error = error {
            userInfo = ["error": error]
        }
        NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
    }
    
}




