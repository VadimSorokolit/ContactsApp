//
//  ContactsViewModel.swift
//  ContactsApp
//
//  Created by Vadim Sorokolit on 20.06.2024.
//

import Foundation

class ContactsViewModel {
    
    // MARK: - Objects
    
    private struct Constants {
        static let errorContactIndex: String = "Contact with index doesn't exist"
        static let errorContactEmail: String = "Email contact shouldn't be nil"
        static let userInfoKey: String = "error"
    }
    
    // MARK: - Properties
    
    private let contactsService: IAPIContacts
    private(set) var contacts: [ContactStruct] = []
    
    // MARK: - Initializer
    
    init(service: IAPIContacts) {
        self.contactsService = service
    }
    
    // MARK: - Methods
    
    func fetchContacts() {
        self.contactsService.fetchContacts(completion: { (fetchResult: Result<[ContactEntity], Error>) -> Void in
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
        self.contactsService.searchContacts(byFullName: query, jobPosition: query, completion: { (searchResult: Result<[ContactEntity], Error>) -> Void in
            switch searchResult {
                case .success(let foundContacts):
                    self.contacts = foundContacts.map({ $0.asStruct() })
                    self.notify(name: .success)
                case .failure(let error):
                    self.notify(name: .errorNotification, errorMessage: error.localizedDescription)
            }
        })
    }

    func saveContact(contact: ContactStruct) {
        self.contactsService.saveContact(contact: contact, completion: { (saveResult: Result<Void, Error>) -> Void in
            switch saveResult {
                case .success(()):
                    self.contacts.append(contact)
                    self.notify(name: .success)
                case .failure(let error):
                    self.notify(name: .errorNotification, errorMessage: error.localizedDescription)
            }
        })
    }
    
    func updateContact(contact: ContactStruct) {
        self.contactsService.updateContact(editedContact: contact, completion: { (updateResult: Result<Void, Error>) -> Void in
            switch updateResult {
                case .success(()):
                    if let contactIndex = self.contacts.firstIndex(where: { $0.email == contact.email }) {
                        self.contacts[contactIndex] = contact
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
    
    func updateOrSave(contact: ContactStruct) {
        guard let contactEmail = contact.email, !contactEmail.isEmpty else {
            let errorMessage = Constants.errorContactEmail
            self.notify(name: .errorNotification, errorMessage: errorMessage)
            return
        }
        self.contactsService.isContactExist(byEmail: contactEmail, completion: { (isExistResult: Result<Bool, Error>) -> Void in
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
    
    func deleteContact(byEmail email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        self.contactsService.deleteContact(byEmail: email, completion: { (deleteResult: Result<Void, Error>) -> Void in
            switch deleteResult {
                case .success(()):
                    self.contacts = self.contacts.filter({ $0.email != email })
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
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




