//
//  EmptyModalViewController.swift
//  ContactsApp
//
//  Created by Vadim Sorokolit on 16.07.2024.
//

import Foundation
import UIKit

class EmptyModalViewController: UIViewController {
    
    // MARK: - Objects
    
    private struct Constants {
        static let backgroundColor: UIColor = UIColor(hexString: "FFFFFF")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    // MARK: - Methods
    
    private func setup() {
        self.setupViews()
    }
    
    private func setupViews() {
        self.view.backgroundColor = Constants.backgroundColor
    }
    
}
