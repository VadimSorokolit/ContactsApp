//
//  ContactsAppTests.swift
//  ContactsAppTests
//
//  Created by Vadym Sorokolit on 05.06.2024.
//

import XCTest
import CoreData
@testable import ContactsApp

class ContactsAppTests: XCTestCase {
    
    // MARK: - Properties
    
    private var clientsService: CoreDataService!
    
    private var fullName: String = "Vadym Sorokolit"
    private var jobPosition: String = "iOS Developer"
    private var email: String = "macintosh@email.ua"
    private var photo: UIImage? = nil
    
    // MARK: - Methods
    
    override func setUp() {
        let testContainer = NSPersistentContainer(name: "ContactsApp")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        testContainer.persistentStoreDescriptions = [description]
        testContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            testContainer.viewContext.automaticallyMergesChangesFromParent = true
            if let error = error as NSError? {
                XCTAssertNil(error, "Failed to load CoreData stack: \(error.localizedDescription)")
            }
        })
        self.clientsService = CoreDataService(pc: testContainer)
    }
    
    override func tearDown() {
        self.clientsService = nil
    }
    
    func test_FetchContacts() {
        let contacts = self.clientsService.fetchContacts()
        let firstContact = contacts.first
        XCTAssertNil(firstContact)
        XCTAssertEqual(contacts.count, 0, "Expected no contacts initially")
    }
    
    func test_FetchContact() {
        let contact = self.clientsService.fetchContact(byEmail: self.email)
        XCTAssertNil(contact)
    }
    
    func test_CreateContact() {
        self.clientsService.createContact(fullName: self.fullName, jobPosition: self.jobPosition, email: self.email, photo: self.photo)
        let contact = self.clientsService.fetchContact(byEmail: self.email)
                XCTAssertNotNil(contact, "Expected to find the contact after adding")
        XCTAssertEqual(contact?.email, self.email, "Fetched contact's email should match the provided email")
        XCTAssertEqual(contact?.fullName, self.fullName, "Fetched contact's full name should match the provided full name")
        XCTAssertEqual(contact?.jobPosition, self.jobPosition, "Fetched contact's job position should match the provided job position")
    }
    
    func test_UpdateContact() {
        self.clientsService.updateContact(byEmail: self.email, jobPosition: "Developer")
        let contact = self.clientsService.fetchContact(byEmail: self.email)
        XCTAssertNotEqual(contact?.jobPosition, self.jobPosition, "Fetched contact's job position should not match the provided job position")
    }
    
    func test_DelteAllContacts() {
        self.clientsService.createContact(fullName: self.fullName, jobPosition: self.jobPosition, email: self.email, photo: nil)
        self.clientsService.deleteAllContacts()
        let contacts = self.clientsService.fetchContacts()
        XCTAssertTrue(contacts.isEmpty, "Expected all contacts to be deleted")
    }
    
    func test_DeleteContact() {
        self.clientsService.createContact(fullName: self.fullName, jobPosition: self.jobPosition, email: self.email, photo: nil)
        self.clientsService.createContact(fullName: self.fullName, jobPosition: self.jobPosition, email: "macintosh@ukr.net", photo: nil)
        self.clientsService.deleteContact(byEmail: self.email)
        let contact = self.clientsService.fetchContact(byEmail: self.email)
        XCTAssertNil(contact, "Expected the contact to be deleted")
    }
    
}
