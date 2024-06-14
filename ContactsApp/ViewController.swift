//
//  ViewController.swift
//  ContactsApp
//
//  Created by Vadym Sorokolit on 05.06.2024.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Initializer
    
    private let CoreDataServiceShared = CoreDataService.shared
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
    }

}


