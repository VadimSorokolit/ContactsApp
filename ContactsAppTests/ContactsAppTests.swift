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
    
    override func tearDown() {
        self.coreDataService = nil
    }
    
    // MARK: - Test methods
    
    func test_FetchContacts() {
        do {
            let contacts = try self.coreDataService.fetchContacts()
            let firstContact = contacts.first
            
            XCTAssertNil(firstContact)
            XCTAssertEqual(contacts.count, 0)
        } catch {
            let error = error
            
            XCTAssertThrowsError(error)
        }
    }

    func test_FetchContact() {
        do {
            let contact = try self.coreDataService.fetchContact(byEmail: self.testEmail)
            
            XCTAssertNotEqual(contact?.email, self.testEmail)
        } catch {
            let error = error
            
            XCTAssertThrowsError(error)
        }
    }

    func test_CreateContact() {
        do {
            let contact = try self.coreDataService.createContact(fullName: self.testFullName, jobPosition: self.testJobPosition, email: self.testEmail, photo: self.testPhoto)
            
            XCTAssertNotNil(contact)
            XCTAssertEqual(contact?.email, self.testEmail)
            XCTAssertEqual(contact?.fullName, self.testFullName)
            XCTAssertEqual(contact?.jobPosition, self.testJobPosition)
        } catch {
            let error = error
            
            XCTAssertThrowsError(error)
        }
    }
    
    func test_UpdateContact() {
        do {
            _ = try self.coreDataService.createContact(fullName: self.testFullName, jobPosition: self.testJobPosition, email: self.testEmail, photo: self.testPhoto)
            let contact = try self.coreDataService.updateContact(byEmail: self.testEmail, jobPosition: self.testNewJobPosition)
            
            XCTAssertEqual(contact?.jobPosition, self.testNewJobPosition)
        } catch {
            let error = error
            
            XCTAssertThrowsError(error)
        }
    }
    
    func test_DeleteContact() {
        do {
            _ = try self.coreDataService.createContact(fullName: self.testFullName, jobPosition: self.testJobPosition, email: self.testEmail, photo: self.testPhoto)
            _ = try self.coreDataService.deleteContact(byEmail: self.testEmail)
            let contact = try self.coreDataService.fetchContact(byEmail: self.testEmail)
            
            XCTAssertEqual(contact, nil)
        } catch {
            let error = error
            
            XCTAssertThrowsError(error)
        }
    }
    
    func test_DeleteAllContacts() {
        do {
            _ = try self.coreDataService.createContact(fullName: self.testFullName, jobPosition: self.testJobPosition, email: self.testEmail, photo: self.testPhoto)
            try self.coreDataService.deleteAllContacts()
            let contacts = try self.coreDataService.fetchContacts()
            
            XCTAssertTrue(contacts.isEmpty)
        } catch {
            let error = error
            
            XCTAssertThrowsError(error)
        }
    }
    
}
