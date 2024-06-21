//
//  ContactsAppTests.swift
//  ContactsAppTests
//
//  Created by Vadim Sorokolit on 05.06.2024.
//

import XCTest
import CoreData
@testable import ContactsApp

class ContactsAppTests: XCTestCase {
    
    // MARK: - Properties
    
    private var coreDataService: CoreDataService!
    
    private var fetchedContacts: [Contact] = []
    private var testFullName: String = "Vadym Sorokolit"
    private var testJobPosition: String = "iOS Developer"
    private var testNewJobPosition: String = "Develper"
    private var testEmail: String = "macintosh@email.ua"
    private var testPhoto: UIImage? = nil
    
    // MARK: - SetUp methods
    
    override func setUp() {
        let mockPersistentContainer = self.createMockPersistentContainer()
        self.coreDataService = CoreDataService(persistentContainer: mockPersistentContainer)
    }
    
    override func tearDown() {
        self.coreDataService = nil
    }
    
    private func createMockPersistentContainer() -> NSPersistentContainer {
        let testContainer = NSPersistentContainer(name: "ContactsApp")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        testContainer.persistentStoreDescriptions = [description]
        testContainer.loadPersistentStores(completionHandler: { (storeDescription: NSPersistentStoreDescription, error: (any Error)?) -> Void in
            testContainer.viewContext.automaticallyMergesChangesFromParent = true
            if let error = error as NSError? {
                XCTAssertNil(error, "Failed to load CoreData stack: \(error.localizedDescription)")
            }
        })
        return testContainer
    }
    
    // MARK: - Test methods
    
    func test_FetchContacts() {
        do {
            self.fetchedContacts = try self.coreDataService.fetchContacts()
            
            XCTAssertTrue(self.fetchedContacts.isEmpty)
            
            let createdContact = try self.coreDataService.createContact(fullName: self.testFullName, jobPosition: self.testJobPosition, email: self.testEmail, photo: self.testPhoto)
            
            XCTAssertNotNil(createdContact)
            XCTAssertNotNil(createdContact?.email)
            XCTAssertEqual(createdContact?.email, self.testEmail)
            
            self.fetchedContacts = try self.coreDataService.fetchContacts()
            if let contact = self.fetchedContacts.first(where: { (contact: Contact) -> Bool in
                contact.email == createdContact?.email
            }) {
                
                XCTAssertNotNil(self.fetchedContacts)
                XCTAssertNotEqual(self.fetchedContacts.count, 0)
                XCTAssertEqual(self.fetchedContacts.count, 1)
            }
            if let createdContactEmail = createdContact?.email {
                let deletedContact = try self.coreDataService.deleteContact(byEmail: createdContactEmail)
                
                XCTAssertNotNil(deletedContact)
                
                self.fetchedContacts = try self.coreDataService.fetchContacts()
                
                XCTAssertTrue(self.fetchedContacts.isEmpty)
            }
        } catch {
            
            XCTAssertThrowsError(error)
        }
    }
    
    func test_FetchContact() {
        do {
            var fetchedContact = try self.coreDataService.fetchContact(byEmail: testEmail)
            
            XCTAssertNil(fetchedContact)
            
            self.fetchedContacts = try self.coreDataService.fetchContacts()
            
            XCTAssertTrue(self.fetchedContacts.isEmpty)
            
            let createdContact = try self.coreDataService.createContact(fullName: self.testFullName, jobPosition: self.testJobPosition, email: self.testEmail, photo: self.testPhoto)
            
            XCTAssertNotNil(createdContact)
            XCTAssertNotNil(createdContact?.email)
            XCTAssertEqual(createdContact?.email, self.testEmail)
            
            fetchedContact = try self.coreDataService.fetchContact(byEmail: self.testEmail)
            
            XCTAssertNotNil(fetchedContact)
            XCTAssertEqual(fetchedContact?.email, self.testEmail)
            
            self.fetchedContacts = try self.coreDataService.fetchContacts()
            
            XCTAssertFalse(self.fetchedContacts.isEmpty)
            XCTAssertEqual(self.fetchedContacts.count, 1)
            
            let deletedContact = try self.coreDataService.deleteContact(byEmail: self.testEmail)
            
            XCTAssertNotNil(deletedContact)
            
            fetchedContact = try self.coreDataService.fetchContact(byEmail: self.testEmail)
            
            XCTAssertNil(fetchedContact)
            
            self.fetchedContacts = try self.coreDataService.fetchContacts()
            
            XCTAssertTrue(self.fetchedContacts.isEmpty)
        } catch {
            
            XCTAssertThrowsError(error)
        }
    }
    
    func test_CreateContact() {
        do {
            self.fetchedContacts = try self.coreDataService.fetchContacts()
            
            XCTAssertTrue(self.fetchedContacts.isEmpty)
            
            let createdContact = try self.coreDataService.createContact(fullName: self.testFullName, jobPosition: self.testJobPosition, email: self.testEmail, photo: self.testPhoto)
            
            XCTAssertNotNil(createdContact)
            XCTAssertEqual(createdContact?.email, self.testEmail)
            XCTAssertEqual(createdContact?.fullName, self.testFullName)
            XCTAssertEqual(createdContact?.jobPosition, self.testJobPosition)
            
            if let createdContactEmail = createdContact?.email {
                let fetchedContact = try self.coreDataService.fetchContact(byEmail: createdContactEmail)
                
                XCTAssertNotNil(fetchedContact)
                XCTAssertEqual(fetchedContact?.email, testEmail)
                
                self.fetchedContacts = try self.coreDataService.fetchContacts()
                
                XCTAssertFalse(self.fetchedContacts.isEmpty)
                XCTAssertEqual(self.fetchedContacts.count, 1)
                
                let deletedContact = try self.coreDataService.deleteContact(byEmail: createdContactEmail)
                
                XCTAssertNotNil(deletedContact)
                
                self.fetchedContacts = try self.coreDataService.fetchContacts()
                
                XCTAssertTrue(self.fetchedContacts.isEmpty)
                XCTAssertEqual(self.fetchedContacts.count, 0)
            }
        } catch {
            
            XCTAssertThrowsError(error)
        }
    }
    
    func test_UpdateContact() {
        do {
            self.fetchedContacts = try self.coreDataService.fetchContacts()
            
            XCTAssertTrue(self.fetchedContacts.isEmpty)
            
            let createdContact = try self.coreDataService.createContact(fullName: self.testFullName, jobPosition: self.testJobPosition, email: self.testEmail, photo: self.testPhoto)
            
            XCTAssertNotNil(createdContact)
            XCTAssertEqual(createdContact?.email, self.testEmail)
            XCTAssertEqual(createdContact?.fullName, self.testFullName)
            XCTAssertEqual(createdContact?.jobPosition, self.testJobPosition)
            
            self.fetchedContacts = try self.coreDataService.fetchContacts()
            
            XCTAssertFalse(self.fetchedContacts.isEmpty)
            XCTAssertEqual(self.fetchedContacts.count, 1)
            
            if let createdContactEmail = createdContact?.email {
                let updatedcontact = try self.coreDataService.updateContact(byEmail: createdContactEmail, jobPosition: self.testNewJobPosition)
                
                XCTAssertEqual(updatedcontact?.jobPosition, self.testNewJobPosition)
                
                let fetchContacted = try self.coreDataService.fetchContact(byEmail: createdContactEmail)
                
                XCTAssertEqual(fetchContacted?.email, createdContactEmail)
                XCTAssertEqual(fetchContacted?.email, self.testEmail)
                
                if let updatedContactEmail = updatedcontact?.email {
                    let deletedContact = try self.coreDataService.deleteContact(byEmail: updatedContactEmail)
                    
                    XCTAssertNotNil(deletedContact)
                    XCTAssertEqual(deletedContact?.email, createdContact?.email)
                    
                    self.fetchedContacts = try self.coreDataService.fetchContacts()
                    
                    XCTAssertTrue(self.fetchedContacts.isEmpty)
                    XCTAssertEqual(self.fetchedContacts.count, 0)
                }
            }
        } catch {
            
            XCTAssertThrowsError(error)
        }
    }
    
    func test_DeleteContact() {
        do {
            self.fetchedContacts = try self.coreDataService.fetchContacts()
            
            XCTAssertTrue(self.fetchedContacts.isEmpty)
            
            let createdContact = try self.coreDataService.createContact(fullName: self.testFullName, jobPosition: self.testJobPosition, email: self.testEmail, photo: self.testPhoto)
            
            XCTAssertNotNil(createdContact)
            XCTAssertEqual(createdContact?.email, self.testEmail)
            XCTAssertEqual(createdContact?.fullName, self.testFullName)
            XCTAssertEqual(createdContact?.jobPosition, self.testJobPosition)
            
            self.fetchedContacts = try self.coreDataService.fetchContacts()
            
            XCTAssertFalse(self.fetchedContacts.isEmpty)
            XCTAssertEqual(self.fetchedContacts.count, 1)
            
            if let createdContactEmail = createdContact?.email {
                let fetchedContact = try self.coreDataService.fetchContact(byEmail: createdContactEmail)
                
                XCTAssertEqual(fetchedContact?.email, createdContactEmail)
                XCTAssertEqual(fetchedContact?.email, self.testEmail)
                
                let deletedContact = try self.coreDataService.deleteContact(byEmail: createdContactEmail)
                
                XCTAssertNotNil(deletedContact)
                XCTAssertEqual(deletedContact?.email, createdContact?.email)
                
                self.fetchedContacts = try self.coreDataService.fetchContacts()
                
                XCTAssertTrue(self.fetchedContacts.isEmpty)
            }
            
        } catch {
            
            XCTAssertThrowsError(error)
        }
    }
    
    func test_DeleteAllContacts() {
        do {
            self.fetchedContacts = try self.coreDataService.fetchContacts()
            
            XCTAssertTrue(self.fetchedContacts.isEmpty)
            
            let createdContact = try self.coreDataService.createContact(fullName: self.testFullName, jobPosition: self.testJobPosition, email: self.testEmail, photo: self.testPhoto)
            
            XCTAssertNotNil(createdContact)
            XCTAssertEqual(createdContact?.email, self.testEmail)
            XCTAssertEqual(createdContact?.fullName, self.testFullName)
            XCTAssertEqual(createdContact?.jobPosition, self.testJobPosition)
            
            self.fetchedContacts = try self.coreDataService.fetchContacts()
            
            XCTAssertFalse(self.fetchedContacts.isEmpty)
            XCTAssertEqual(self.fetchedContacts.count, 1)
            
            if let createdContactEmail = createdContact?.email {
                let fetchedContact = try self.coreDataService.fetchContact(byEmail: createdContactEmail)
                
                XCTAssertEqual(fetchedContact?.email, createdContactEmail)
                XCTAssertEqual(fetchedContact?.email, self.testEmail)
            }
            try self.coreDataService.deleteAllContacts()
            self.fetchedContacts = try self.coreDataService.fetchContacts()
            
            XCTAssertTrue(self.fetchedContacts.isEmpty)
        } catch {
            
            XCTAssertThrowsError(error)
        }
    }
    
}
