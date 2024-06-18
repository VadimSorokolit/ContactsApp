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
    
    var clientsService: CoreDataService!

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
        clientsService = CoreDataService(pc: testContainer)
    }
    
    override func tearDown() {
        clientsService = nil
    }
    
    func test_fetchContacts() {
        let contacts = clientsService.fetchContacts()
        let firstContact = contacts.first
        XCTAssertNil(firstContact)
    }

}
