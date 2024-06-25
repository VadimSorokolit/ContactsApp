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
    
    private var testFullName: String = "Vadim Sorokolit"
    private var testNewFullName: String = "Alex Sorokolit"
    private var testJobPosition: String = "iOS Developer"
    private var testNewJobPosition: String = "Developer"
    private var testEmail: String = "macintosh@email.ua"
    private var testNewEmail: String = "macintosh@ukr.net"
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
        testContainer.loadPersistentStores(completionHandler: { (storeDescription: NSPersistentStoreDescription, error: Error?) -> Void in
            testContainer.viewContext.automaticallyMergesChangesFromParent = true
            if let error {
                XCTAssertNil(error, "Failed to load CoreData stack: \(error.localizedDescription)")
            }
        })
        return testContainer
    }
    
    // MARK: - Test methods
    
    func test_FetchContacts() {
        do {
            let createdContact = try self.coreDataService.createContact(fullName: self.testFullName, jobPosition: self.testJobPosition, email: self.testEmail, photo: self.testPhoto)
            
            XCTAssertNotNil(createdContact)
            XCTAssertEqual(createdContact?.email, self.testEmail)
            
            let fetchedContacts = try self.coreDataService.fetchContacts()
            if let fetchedContact = fetchedContacts.first(where: { (contact: Contact) -> Bool in
                contact.email == createdContact?.email
            }) {
                XCTAssertFalse(fetchedContacts.isEmpty)
                XCTAssertEqual(fetchedContact.email, createdContact?.email)
            }
        } catch {
            XCTAssertThrowsError(error)
        }
    }
    
    func test_FetchContact() {
        do {
            let createdContact = try self.coreDataService.createContact(fullName: self.testFullName, jobPosition: self.testJobPosition, email: self.testEmail, photo: self.testPhoto)
            
            XCTAssertNotNil(createdContact)
            XCTAssertEqual(createdContact?.email, self.testEmail)
            
            if let createdContactEmail = createdContact?.email {
                let fetchedContact = try self.coreDataService.fetchContact(byEmail: createdContactEmail)
                
                XCTAssertNotNil(fetchedContact)
                XCTAssertEqual(fetchedContact, createdContact)
            }
        } catch {
            XCTAssertThrowsError(error)
        }
    }
    
    func test_SearchContacts() {
        do {
            _ = try self.coreDataService.createContact(fullName: self.testFullName, jobPosition: self.testJobPosition, email: self.testEmail, photo: self.testPhoto)
            _ = try self.coreDataService.createContact(fullName: self.testNewFullName, jobPosition: self.testNewJobPosition, email: self.testNewEmail, photo: self.testPhoto)
            let foundContacts = try self.coreDataService.searchContacts(byFullName: self.testFullName, jobPosition: self.testNewJobPosition)
            print("Found Contacts:")
            for contact in foundContacts {
                print("\(contact.fullName ?? "<empty>") - \(contact.jobPosition ?? "<empty>")")
            }
            XCTAssertEqual(foundContacts.count, 2)
        } catch {
            XCTAssertThrowsError(error)
        }
    }
    
    func test_CreateContact() {
        do {
            let createdContact = try self.coreDataService.createContact(fullName: self.testFullName, jobPosition: self.testJobPosition, email: self.testEmail, photo: self.testPhoto)
            
            XCTAssertNotNil(createdContact)
            XCTAssertEqual(createdContact?.email, self.testEmail)
            
            if let createdContactEmail = createdContact?.email {
                let fetchedContact = try self.coreDataService.fetchContact(byEmail: createdContactEmail)
                
                XCTAssertNotNil(fetchedContact)
                XCTAssertEqual(fetchedContact?.email, createdContactEmail)
            }
        } catch {
            XCTAssertThrowsError(error)
        }
    }
    
    func test_UpdateContact() {
        do {
            let createdContact = try self.coreDataService.createContact(fullName: self.testFullName, jobPosition: self.testJobPosition, email: self.testEmail, photo: self.testPhoto)
            
            XCTAssertNotNil(createdContact)
            XCTAssertEqual(createdContact?.email, self.testEmail)
            
            if let createdContactEmail = createdContact?.email {
                let updatedcontact = try self.coreDataService.updateContact(byEmail: createdContactEmail, jobPosition: self.testNewJobPosition)
                
                XCTAssertEqual(updatedcontact?.email, createdContactEmail)
                XCTAssertEqual(updatedcontact?.jobPosition, self.testNewJobPosition)
            }
        } catch {
            XCTAssertThrowsError(error)
        }
    }
    
    func test_DeleteContact() {
        do {
            let createdContact = try self.coreDataService.createContact(fullName: self.testFullName, jobPosition: self.testJobPosition, email: self.testEmail, photo: self.testPhoto)
            
            XCTAssertNotNil(createdContact)
            XCTAssertEqual(createdContact?.email, self.testEmail)
            
            if let createdContactEmail = createdContact?.email {
                let deletedContact = try self.coreDataService.deleteContact(byEmail: createdContactEmail)
                
                XCTAssertNotNil(deletedContact)
                XCTAssertEqual(deletedContact?.email, createdContact?.email)
                
                if let deletedContactEmail = deletedContact?.email {
                    let deletedContact = try self.coreDataService.fetchContact(byEmail: deletedContactEmail)
                    
                    XCTAssertNil(deletedContact)
                }
            }
        } catch {
            XCTAssertThrowsError(error)
        }
    }
    
    func test_DeleteAllContacts() {
        do {
            let createdContact = try self.coreDataService.createContact(fullName: self.testFullName, jobPosition: self.testJobPosition, email: self.testEmail, photo: self.testPhoto)
            
            XCTAssertNotNil(createdContact)
            XCTAssertEqual(createdContact?.email, self.testEmail)
            
            if let createdContactEmail = createdContact?.email {
                let fetchedContact = try self.coreDataService.fetchContact(byEmail: createdContactEmail)
                
                XCTAssertEqual(fetchedContact?.email, createdContactEmail)
            }
            try self.coreDataService.deleteAllContacts()
            let fetchedContacts = try self.coreDataService.fetchContacts()
            
            XCTAssertTrue(fetchedContacts.isEmpty)
        } catch {
            XCTAssertThrowsError(error)
        }
    }
    
}
