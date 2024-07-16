//
//  EditContactController.swift
//  ContactsApp
//
//  Created by Vadim Sorokoliton 16.07.2024.
//

import Foundation
import UIKit

class EditContactController: UIViewController {
    
    // MARK: - Objects
    
    private struct Constants {
        static let backgroundColor: UIColor = UIColor(hexString: "447BF1")
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
