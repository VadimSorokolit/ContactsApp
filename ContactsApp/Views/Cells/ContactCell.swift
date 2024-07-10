//
//  ContactCell.swift
//  ContactsApp
//
//  Created by Vadim Sorokolit on 10.07.2024.
//

import Foundation
import UIKit
import SnapKit

class ContactCell: UITableViewCell {
    
    // MARK: - Objects
    
    private struct LocalConstants {
        static let reuseIDName: String = "ContactCell"
    }
    
    // MARK: - Properties
    
    static let reuseID = LocalConstants.reuseIDName
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError(GlobalConstants.fatalError)
    }
    
}
