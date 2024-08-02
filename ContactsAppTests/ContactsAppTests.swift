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
    
    private let testFullName: String = "Ivan Sorokolit"
    private let testNewFullName: String = "Igor Sorokolit"
    private let testJobPosition: String = "iOS Developer"
    private let testNewJobPosition: String = "Developer"
    private let testEmail: String = "macintosh@email.ua"
    private let testNewEmail: String = "macintosh@ukr.net"
    private let testPhoto: Data? = UIImage(systemName: "photo")?.pngData()
    private let testNewPhoto: Data? = UIImage(systemName: "person")?.pngData()
    private let testQuery: String = "i"
    
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
        let expectation = XCTestExpectation(description: "Fetch contacts expectation")
        
        var newContact = ContactStruct()
        
        newContact.email = self.testEmail
        
        XCTAssertNotNil(newContact.email)
        
        self.coreDataService.saveContact(contact: newContact, completion: { (saveResult: Result<Void, Error>) -> Void in
            switch saveResult {
                case .success(()):
                    self.coreDataService.fetchContacts(completion: { (fetchResult: Result<[ContactEntity], Error>) -> Void in
                        switch fetchResult {
                            case .success(let contacts):
                                
                                XCTAssertFalse(contacts.isEmpty)
                                XCTAssertTrue(contacts.contains(where: { $0.email == self.testEmail }))
                                
                            case .failure(let error):
                                
                                XCTFail(error.localizedDescription)
                        }
                        expectation.fulfill()
                    })
                    
                case .failure(let error):
                    
                    XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_FetchContact() {
        let expectation = XCTestExpectation(description: "Fetch contact expectation")
        
        var newContact = ContactStruct()
        
        newContact.fullName = self.testFullName
        newContact.email = self.testEmail
        
        XCTAssertNotNil(newContact.fullName)
        XCTAssertNotNil(newContact.email)
        
        self.coreDataService.saveContact(contact: newContact, completion: { (saveResult: Result<Void, Error>) -> Void in
            switch saveResult {
                case .success(()):
                    
                    guard let contactEmail = newContact.email else {
                        
                        XCTFail("Contact email should not be nil")
                        expectation.fulfill()
                        return
                    }
                    
                    self.coreDataService.fetchContact(byEmail: contactEmail, completion: { (fetchResult: Result<ContactEntity?, Error>) -> Void in
                        switch fetchResult {
                            case .success(let contact):
                                
                                XCTAssertNotNil(contact)
                                
                            case .failure(let error):
                                
                                XCTFail(error.localizedDescription)
                        }
                        expectation.fulfill()
                    })
                    
                case .failure(let error):
                    
                    XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_SearchContacts() {
        let expectation = XCTestExpectation(description: "Search contacts expectation")
        
        var contact1 = ContactStruct()
        contact1.fullName = self.testFullName
        contact1.jobPosition = self.testJobPosition
        contact1.email = self.testEmail
        
        var contact2 = ContactStruct()
        contact2.fullName = self.testNewFullName
        contact2.jobPosition = self.testNewJobPosition
        contact2.email = self.testNewEmail
        
        let contacts = [contact1, contact2]
        var saveCount = 0
        
        for contact in contacts {
            self.coreDataService.saveContact(contact: contact, completion: { (result: Result<Void, Error>) -> Void in
                switch result {
                    case .success(()):
                        
                        saveCount += 1
                        
                        if saveCount == contacts.count {
                            
                            self.coreDataService.searchContacts(byFullName: self.testFullName, jobPosition: nil, completion: { (searchResult: Result<[ContactEntity], Error>) -> Void in
                                switch searchResult {
                                    case .success(let foundContacts):
                                        
                                        XCTAssertTrue(foundContacts.contains(where: { $0.email == self.testEmail }))
                                        
                                        XCTAssertFalse(foundContacts.contains(where: { $0.email == self.testNewEmail }))
                                        
                                        self.coreDataService.searchContacts(byFullName: nil, jobPosition: self.testNewJobPosition, completion: { (searchResult: Result<[ContactEntity], Error>) -> Void in
                                            switch searchResult {
                                                case .success(let foundContacts):
                                                    
                                                    XCTAssertTrue(foundContacts.contains(where: { $0.email == self.testNewEmail }))
                                                    
                                                    XCTAssertTrue(foundContacts.contains(where: { $0.email == self.testEmail }))
                                                    expectation.fulfill()
                                                    
                                                case .failure(let error):
                                                    
                                                    XCTFail(error.localizedDescription)
                                                    expectation.fulfill()
                                            }
                                        })
                                        
                                    case .failure(let error):
                                        XCTFail(error.localizedDescription)
                                        expectation.fulfill()
                                }
                            })
                        }
                    case .failure(let error):
                        
                        XCTFail(error.localizedDescription)
                        expectation.fulfill()
                }
            })
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_saveContact() {
        let expectation = XCTestExpectation(description: "Save all contacts expectation")
        
        var newContact = ContactStruct()

        newContact.fullName = self.testFullName
        newContact.jobPosition = self.testJobPosition
        newContact.email = self.testNewEmail
        newContact.photo = self.testPhoto
        
        self.coreDataService.saveContact(contact: newContact, completion: { (saveResult: Result<Void, Error>) -> Void in
            switch saveResult {
                case .success(()):
                    
                    guard let contactEmail = newContact.email else {
                        
                        XCTFail("Contact email should not be nil")
                        expectation.fulfill()
                        return
                    }
                    
                    self.coreDataService.isContactExist(byEmail: contactEmail, completion: { (isExistResult: Result<Bool, Error>) -> Void in
                        switch isExistResult {
                            case .success(let isExist):
                                
                                XCTAssertTrue(isExist)
                                
                            case .failure(let error):
                                
                                XCTFail(error.localizedDescription)
                        }
                        
                        expectation.fulfill()
                    })
                    
                case .failure(let error):
                    
                    XCTFail(error.localizedDescription)
                    
                    expectation.fulfill()
            }
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_UpdateContact() {
        let expectation = XCTestExpectation(description: "Update contact expectation")
        
        var newContact = ContactStruct()
        
        newContact.email = self.testEmail
        
        XCTAssertNotNil(newContact.email)
        
        self.coreDataService.saveContact(contact: newContact, completion: { (saveResult: Result<Void, Error>) -> Void in
            switch saveResult {
                case .success(()):
                    guard let contactEmail = newContact.email else {
                        
                        XCTFail("Email contact should not be nil")
                        expectation.fulfill()
                        return
                    }
                    
                    self.coreDataService.isContactExist(byEmail: contactEmail, completion: { (isExistResult: Result<Bool, Error>) -> Void in
                        switch isExistResult {
                            case .success(let isContactExist):
                                
                                XCTAssertTrue(isContactExist)
                                
                                newContact.fullName = self.testFullName
                                newContact.jobPosition = self.testJobPosition
                                newContact.photo = self.testPhoto
                                
                                self.coreDataService.updateContact(editedContact: newContact, completion: { (updateResult: Result<Void, Error>) -> Void in
                                    switch updateResult {
                                        case .success(()):
                                            
                                            self.coreDataService.fetchContacts(completion: { (fetchResult: Result<[ContactEntity], Error>) -> Void in
                                                switch fetchResult {
                                                    case .success(let contacts):
                                                        
                                                        if let updatedContact = contacts.first(where: { $0.email == self.testEmail }) {
                                                            
                                                            XCTAssertEqual(updatedContact.fullName, self.testFullName)
                                                            XCTAssertEqual(updatedContact.jobPosition, self.testJobPosition)
                                                            XCTAssertNotEqual(updatedContact.email, self.testNewEmail)
                                                            XCTAssertEqual(updatedContact.photo, self.testPhoto)
                                                        } else {
                                                            
                                                            XCTFail("Contact with new email not found")
                                                        }
                                                        
                                                    case .failure(let error):
                                                        
                                                        XCTFail(error.localizedDescription)
                                                }
                                                expectation.fulfill()
                                            })
                                            
                                        case .failure(let error):
                                            
                                            XCTFail(error.localizedDescription)
                                    }
                                    expectation.fulfill()
                                })
                                
                            case .failure(let error):
                                
                                XCTFail(error.localizedDescription)
                        }
                        expectation.fulfill()
                    })
                    
                case .failure(let error):
                    
                    XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_DeleteContact() {
        let expectation = XCTestExpectation(description: "Delete contact expectation")
        
        var newContact = ContactStruct()
        
        newContact.email = self.testEmail
        
        XCTAssertNotNil(newContact.email)
        
        self.coreDataService.saveContact(contact: newContact, completion: { (saveResult: Result<Void, Error>) -> Void in
            switch saveResult {
                case .success(()):
                    guard let contactEmail = newContact.email else {
                        
                        XCTFail("Email contact should not be nil")
                        expectation.fulfill()
                        return
                    }
                    
                    self.coreDataService.isContactExist(byEmail: contactEmail, completion: { (isExistResult: Result<Bool, Error>) -> Void in
                        switch isExistResult {
                            case .success(let isContactExists):
                                
                                XCTAssertTrue(isContactExists)
                                
                                self.coreDataService.deleteContact(byEmail: contactEmail, completion: { (deleteResult: Result<Void, Error>) -> Void in
                                    switch deleteResult {
                                        case .success(()):
                                            
                                            self.coreDataService.isContactExist(byEmail: contactEmail, completion: { (postDeleteResult: Result<Bool, Error>) -> Void in
                                                switch postDeleteResult {
                                                    case .success(let isContactExist):
                                                        
                                                        XCTAssertFalse(isContactExist)
                                                        
                                                    case .failure(let error):
                                                        
                                                        XCTFail(error.localizedDescription)
                                                }
                                                expectation.fulfill()
                                            })
                                            
                                        case .failure(let error):
                                            
                                            XCTFail(error.localizedDescription)
                                    }
                                    expectation.fulfill()
                                })
                                
                            case .failure(let error):
                                
                                XCTFail(error.localizedDescription)
                                expectation.fulfill()
                        }
                    })
                    
                case .failure(let error):
                    
                    XCTFail(error.localizedDescription)
                    expectation.fulfill()
            }
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_DeleteAllContacts() {
        let expectation = XCTestExpectation(description: "Delete all contacts expectation")
        
        var newContact = ContactStruct()
        
        newContact.email = self.testEmail
        
        XCTAssertNotNil(newContact.email)
        
        self.coreDataService.saveContact(contact: newContact, completion: { (saveResult: Result<Void, Error>) -> Void in
            switch saveResult {
                case .success(()):
                    guard let contactEmail = newContact.email else {
                        
                        XCTFail("Email contact should not be nil")
                        expectation.fulfill()
                        return
                    }
                    
                    self.coreDataService.isContactExist(byEmail: contactEmail, completion: { (existsResult: Result<Bool, Error>) -> Void in
                        switch existsResult {
                            case .success(let exists):
                                
                                XCTAssertTrue(exists)
                                
                                self.coreDataService.deleteAllContacts(completion: { (deleteResult: Result<Void, Error>) -> Void in
                                    switch deleteResult {
                                        case .success(()):
                                            
                                            self.coreDataService.fetchContacts(completion: { (fetchResult: Result<[ContactEntity], Error>) -> Void in
                                                switch fetchResult {
                                                    case .success(let contacts):
                                                        
                                                        XCTAssertTrue(contacts.isEmpty)
                                                        
                                                        
                                                    case .failure(let error):
                                                        
                                                        XCTFail(error.localizedDescription)
                                                }
                                                expectation.fulfill()
                                            })
                                            
                                        case .failure(let error):
                                            
                                            XCTFail(error.localizedDescription)
                                    }
                                    expectation.fulfill()
                                })
                                
                            case .failure(let error):
                                
                                XCTFail(error.localizedDescription)
                                expectation.fulfill()
                        }
                    })
                    
                case .failure(let error):
                    
                    XCTFail(error.localizedDescription)
                    expectation.fulfill()
            }
        })
        wait(for: [expectation], timeout: 20.0)
    }
    
    func test_isContactExist() {
        let expectation = XCTestExpectation(description: "Is contact exist expectation")
        
        var newContact = ContactStruct()
        
        newContact.email = self.testEmail
        
        self.coreDataService.saveContact(contact: newContact, completion: { (saveResult: Result<Void, Error>) -> Void in
            switch saveResult {
                case .success(()):
                    
                    if let contactEmail = newContact.email {
                        self.coreDataService.isContactExist(byEmail: contactEmail, completion: { (isExistResult: Result<Bool, Error>) -> Void in
                            switch isExistResult {
                                case .success(let isExist):
                                    
                                    XCTAssertTrue(isExist)
                                    
                                case .failure(let error):
                                    
                                    XCTFail(error.localizedDescription)
                            }
                            expectation.fulfill()
                        })
                    } else {
                        
                        XCTFail("Contact email should not be nil")
                    }
                case .failure(let error):
                    
                    XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
}
