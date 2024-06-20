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
        return self.coreDataService.fetchContacts()
    }
    
    func fetchContact(byEmail email: String) -> Contact? {
        return self.coreDataService.fetchContact(byEmail: email)
    }
    
    private func createContact(fullName: String, jobPosition: String, email: String, photo: UIImage?) {
        self.coreDataService.createContact(fullName: fullName, jobPosition: jobPosition, email: email, photo: photo)
    }
    
    private func updateContact(byEmail email: String, jobPostion: String) {
        self.coreDataService.updateContact(byEmail: email, jobPosition: jobPostion)
    }
    
}



