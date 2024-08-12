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
    
    // MARK: - Objects
    
    private struct Constants {
        static let errorContactIndex: String = "Contact with index doesn't exist"
        static let errorContactEmail: String = "Email contact should not be nil"
        static let userInfoKey: String = "error"
    }
    
    // MARK: - Properties
    
    private let service: IAPIContacts
    private(set) var contacts: [ContactStruct] = []
    
    // MARK: - Initializer
    
    init(service: IAPIContacts) {
        self.service = service
    }
    
    // MARK: - Methods
    
    func fetchContacts() {
        self.service.fetchContacts(completion: { (fetchResult: Result<[ContactEntity], Error>) -> Void in
            switch fetchResult {
                case .success(let contacts):
                    self.contacts = contacts.map({ $0.asStruct() })
                    self.notify(name: .success)
                case .failure(let error):
                    self.notify(name: .errorNotification, errorMessage: error.localizedDescription)
            }
        })
    }
    
    func searchContacts(byQuery query: String) {
        self.service.searchContacts(byFullName: query, jobPosition: query, completion: { (searchResult: Result<[ContactEntity], Error>) -> Void in
            switch searchResult {
                case .success(let foundContacts):
                    self.contacts = foundContacts.map({ $0.asStruct() })
                    self.notify(name: .success)
                case .failure(let error):
                    self.notify(name: .errorNotification, errorMessage: error.localizedDescription)
            }
        })
    }
    
    // !!!! Only for test create contacts
    func testCreateContacts() {
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
        
        contact3.fullName = "Marina Nazarenko"
        contact3.jobPosition = "Teacher"
        contact3.email = "everest@i.ua"
        contact3.photo = UIImage(named: "splashScreenImage")?.pngData()
        
        self.service.saveContact(contact: contact1, completion: { (saveResult: Result<Void, Error>) -> Void in
            switch saveResult {
                case .success(()):
                    self.contacts.append(contact1)
                    self.notify(name: .success)
                    
                    self.service.saveContact(contact: contact2, completion: { (saveResult: Result<Void, Error>) -> Void in
                        switch saveResult {
                            case.success(()):
                                self.contacts.append(contact2)
                                self.notify(name: .success)
                                
                                self.service.saveContact(contact: contact3, completion: { (saveResult: Result<Void, Error>) -> Void in
                                    switch saveResult {
                                        case .success(()):
                                            self.contacts.append(contact3)
                                            self.notify(name: .success)
                                        case .failure(let error):
                                            self.notify(name: .errorNotification, errorMessage: error.localizedDescription)
                                    }
                                })
                            case .failure(let error):
                                self.notify(name: .errorNotification, errorMessage: error.localizedDescription)
                        }
                    })
                case.failure(let error):
                    self.notify(name: .errorNotification, errorMessage: error.localizedDescription)
            }
        })
    }
    
    func updateContact(contact: ContactStruct) {
        self.service.updateContact(editedContact: contact, completion: { (updateResult: Result<Void, Error>) -> Void in
            switch updateResult {
                case .success(()):
                    if let index = self.contacts.firstIndex(where: { $0.email == contact.email }) {
                        self.contacts[index] = contact
                        self.notify(name: .success)
                    } else {
                        let error = NSError(domain: Constants.errorContactIndex, code: 1)
                        self.notify(name: .errorNotification, errorMessage: error.localizedDescription)
                    }
                case .failure(let error):
                    self.notify(name: .errorNotification, errorMessage: error.localizedDescription)
            }
        })
    }
    
    // !!!! Only for test delete all contacts
    func deleteAllContacts() {
        self.service.deleteAllContacts(completion: { (deleteResult: Result<Void, Error>) -> Void in
            switch deleteResult {
                case .success(()):
                    self.contacts.removeAll()
                    self.notify(name: .success)
                case .failure(let error):
                    self.notify(name: .errorNotification, errorMessage: error.localizedDescription)
            }
        })
    }
    
    func deleteContact(byEmail email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        self.service.deleteContact(byEmail: email, completion: { (deleteResult: Result<Void, Error>) -> Void in
            switch deleteResult {
                case .success(()):
                    self.contacts = self.contacts.filter({ $0.email != email })
                    completion(.success(()))
                    // For test !!!!!!!!!!!!!!
                    self.notify(name: .success)
                case .failure(let error):
                    completion(.failure(error))
            }
        })
    }
    
    func saveContact(contact: ContactStruct) {
        self.service.saveContact(contact: contact, completion: { (saveResult: Result<Void, Error>) -> Void in
            switch saveResult {
                case .success(()):
                    self.contacts.append(contact)
                    self.notify(name: .success)
                case .failure(let error):
                    self.notify(name: .errorNotification, errorMessage: error.localizedDescription)
            }
        })
    }
    
    func contactVarificationBeforeSave(contact: ContactStruct) {
        guard let contactEmail = contact.email, !contactEmail.isEmpty else {
            let errorMessage = Constants.errorContactEmail
            self.notify(name: .errorNotification, errorMessage: errorMessage)
            return
        }
        
        self.service.isContactExist(byEmail: contactEmail, completion: { (isExistResult: Result<Bool, Error>) -> Void in
            switch isExistResult {
                case .success(let isExist):
                    if isExist {
                        self.updateContact(contact: contact)
                    } else {
                        self.saveContact(contact: contact)
                    }
                case .failure(let error):
                    self.notify(name: .errorNotification, errorMessage: error.localizedDescription)
            }
            
        })
    }
    
    private func notify(name: Notification.Name, errorMessage: String? = nil) {
        var userInfo: [String: String]? = nil
        if let error = errorMessage {
            userInfo = [Constants.userInfoKey: error]
        }
        NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
    }
    
}




