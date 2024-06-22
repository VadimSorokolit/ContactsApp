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
            let createdContact = try self.coreDataService.createContact(fullName: self.testFullName, jobPosition: self.testJobPosition, email: self.testEmail, photo: self.testPhoto)
            
            XCTAssertNotNil(createdContact)
            XCTAssertEqual(createdContact?.email, self.testEmail)
            
            let fetchedContacts = try self.coreDataService.fetchContacts()
            if let contact = fetchedContacts.first(where: { (contact: Contact) -> Bool in
                contact.email == createdContact?.email
            }) {
                
                XCTAssertFalse(fetchedContacts.isEmpty)
                XCTAssertEqual(contact.email, createdContact?.email)
            }
            if let createdContactEmail = createdContact?.email {
                let deletedContact = try self.coreDataService.deleteContact(byEmail: createdContactEmail)
                
                XCTAssertEqual(createdContact, deletedContact)
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
                
                if let fetchedContactEmail = fetchedContact?.email {
                    let deletedContact = try self.coreDataService.deleteContact(byEmail: fetchedContactEmail)
                    
                    XCTAssertNotNil(deletedContact)
                    XCTAssertEqual(deletedContact, createdContact)
                    
                    if let deletedContactEmail = deletedContact?.email {
                        let fetchedContact = try self.coreDataService.fetchContact(byEmail: deletedContactEmail)
                        
                        XCTAssertNil(fetchedContact)
                    }
                }
            }
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
                XCTAssertEqual(fetchedContact?.email, self.testEmail)
                
                let deletedContact = try self.coreDataService.deleteContact(byEmail: createdContactEmail)
                
                XCTAssertNotNil(deletedContact)
                XCTAssertEqual(deletedContact, createdContact)
                
                if let deletedContactEmail = deletedContact?.email {
                    let deletedContact = try self.coreDataService.fetchContact(byEmail: deletedContactEmail)
                    
                    XCTAssertNil(deletedContact)
                }
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
                
                if let updatedContactEmail = updatedcontact?.email {
                    let deletedContact = try self.coreDataService.deleteContact(byEmail: updatedContactEmail)
                    
                    XCTAssertNotNil(deletedContact)
                    XCTAssertEqual(deletedContact?.email, createdContact?.email)
                    
                    if let deletedContactEmail = deletedContact?.email {
                        let deletedContact = try self.coreDataService.fetchContact(byEmail: deletedContactEmail)
                        
                        XCTAssertNil(deletedContact)
                    }
                }
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
