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
    var contacts: [ContactStruct] = []
    
    // MARK: - Methods
    
    func fetchContacts(completion: @escaping (Result<Void, Error>) -> Void) {
        self.coreDataService.fetchContacts { result in
            switch result {
                case .success(let contacts):
                    self.contacts = contacts.map({ $0.asContactStruct() })
                    print("Fetched contacts count: \(self.contacts.count)")
                    self.contacts.forEach { contact in
                        print(9999, contact.fullName, contact.jobPosition)
                    }
                    completion(.success(()))
                    self.notify(name: .success)
                    self.contacts.forEach { contact in
                        print(5555555, contact.fullName, contact.jobPosition)
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                    self.notify(name: .error, error: error.localizedDescription)
            }
        }
    }

    func searchContacts(byQuery query: String) {
        self.coreDataService.searchContacts(byFullName: query, jobPosition: query, completion: { (searchResult: Result<[ContactEntity], Error>) -> Void in
            switch searchResult {
                case .success(let foundContacts):
                    self.contacts = foundContacts.map({ $0.asContactStruct() })
                    self.notify(name: .success)
                case .failure(let error):
                    self.notify(name: .error, error: error.localizedDescription)
            }
        })
    }
    
//    func createNewEmptyContact() -> Contact {
//        let contact = self.coreDataService.createEmptyContact()
//        return contact
//    }

    // !!!! Only for test create contacts
    func testCreateContacts(completion: @escaping () -> Void) {
        var contact1 = ContactStruct()
        var contact2 = ContactStruct()
        var contact3 = ContactStruct()
        
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
                                            self.notify(name: .success)
                                            completion()
                                        case .failure(let error):
                                            self.notify(name: .error, error: error.localizedDescription)
                                    }
                                })
                            case .failure(let error):
                                self.notify(name: .error, error: error.localizedDescription)
                        }
                    })
                case.failure(let error):
                    self.notify(name: .error, error: error.localizedDescription)
            }
        })
    }
     
    // !!!! Only for test delete all contacts
    //    func deleteAllContacts() {
    //        self.coreDataService.deleteAllContacts(completion: { (deleteResult: Result<Void, Error>) -> Void in
    //            switch deleteResult {
    //                case .success(()):
    //                    self.contacts.removeAll()
    //                case .failure(let error):
    //                    print(error.localizedDescription)
    //            }
    //        })
    //    }
    
    func updateContact(contact: ContactStruct) {
        self.coreDataService.updateContact(editedContact: contact, completion: { (updateResult: Result<Void, Error>) -> Void in
            switch updateResult {
                case .success(()):
                    if let index = self.contacts.firstIndex(where: { $0.email == contact.email }) {
                        self.contacts[index] = contact
                        self.notify(name: .success)
                    }
                case .failure(let error):
                    self.notify(name: .error, error: error.localizedDescription)
            }
        })
    }
        
    func deleteContact(byEmail email: String) {
        self.coreDataService.deleteContact(byEmail: email, completion: { (deleteResult: Result<Void, Error>) -> Void in
            switch deleteResult {
                case .success(()):
                    self.contacts = self.contacts.filter { $0.email != email }
                    self.notify(name: .success)
                case .failure(let error):
                    self.notify(name: .error, error: error.localizedDescription)
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




