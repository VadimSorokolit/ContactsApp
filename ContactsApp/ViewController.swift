//
//  ViewController.swift
//  ContactsApp
//
//  Created by Vadym Sorokolit on 05.06.2024.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    private let name: String  = "Vadim"
    private let jobPosition: String = "iOS Developer"
    private let email = "macintosh@email.ua"
    private let photo: UIImage? = nil
    
    // MARK: - Initializer
    
    private let CoreDataServiceShared = CoreDataService.shared
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
//        self.addContact()
        
        if let contact = self.getContact() {
            print("-->", contact.email ?? "No email")
        }
        print("------")
    }
    
    // MARK: - Methods
    
    private func addContact() {
        self.CoreDataServiceShared.createContact(
            name: self.name,
            jobPosition: self.jobPosition,
            email: self.email,
            photo: self.photo)
    }

    private func getContact() -> Contact? {
        let contact = self.CoreDataServiceShared.fetchContact(byEmail: self.email)
        return contact
    }
}
