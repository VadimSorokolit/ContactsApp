//
//  ContactsViewController.swift
//  ContactsApp
//
//  Created by Vadim Sorokolit on 05.06.2024.
//

import UIKit
import SnapKit

class ContactsViewController: UIViewController {
    
    // MARK: - Objects
    
    private struct LocalConstants {
        static let titleLabelFont: UIFont? = UIFont(name: "Manrope-Bold", size: 28.0) ?? UIFont(name: "SF Compact", size: 28.0)
        static let infoLabelFont: UIFont? = UIFont(name: "Manrope-Medium", size: 14.0) ?? UIFont(name: "SF Compact", size: 14.0)
        static let contactsScreenBackgroundColor: UIColor = UIColor(hexString: "FFFFFF")
        static let contactsScreenAddButtonColor: UIColor = UIColor(hexString: "447BF1")
        static let titleLabelTopPadding: CGFloat = 60.0
        static let labelPadding: CGFloat = 30.0
        static let heightLabels: CGFloat = 40.0
        static let addButtonHeight: CGFloat = 70.0
        static let addButtonInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 39.0, right: 27.0)
        static let searchBarPlaceholder = "Search"
        static let infoLabeltext = "💡 Swipe to delete contact from list"
        static let addButtonIconName = "plus"
        static let titleLabelText = "Contacts"
    }
    
    // MARK: - Properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString(LocalConstants.titleLabelText, comment: "")
        label.textAlignment = .left
        label.font = LocalConstants.titleLabelFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = LocalConstants.searchBarPlaceholder
        searchBar.backgroundImage = UIImage()
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString(LocalConstants.infoLabeltext, comment: "")
        label.font = LocalConstants.infoLabelFont
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = LocalConstants.contactsScreenAddButtonColor
        button.tintColor = LocalConstants.contactsScreenBackgroundColor
        button.setImage(UIImage(systemName: LocalConstants.addButtonIconName), for: .normal)
        button.layer.cornerRadius = LocalConstants.addButtonHeight / 2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
        self.view.backgroundColor = LocalConstants.contactsScreenBackgroundColor
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.infoLabel)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.addButton)
        
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: LocalConstants.labelPadding),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -LocalConstants.labelPadding),
            self.titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: LocalConstants.titleLabelTopPadding),
            self.titleLabel.heightAnchor.constraint(equalToConstant: LocalConstants.heightLabels),
            
            self.searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: LocalConstants.labelPadding - CGFloat(LocalConstants.searchBarPlaceholder.count)),
            self.searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -LocalConstants.labelPadding),
            self.searchBar.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor),
            self.searchBar.heightAnchor.constraint(equalToConstant: LocalConstants.heightLabels),
            
            self.infoLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: LocalConstants.labelPadding),
            self.infoLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -LocalConstants.labelPadding),
            self.infoLabel.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor),
            self.infoLabel.heightAnchor.constraint(equalToConstant: LocalConstants.heightLabels),
            
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.infoLabel.bottomAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            self.addButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -LocalConstants.addButtonInsets.right),
            self.addButton.heightAnchor.constraint(equalToConstant: LocalConstants.addButtonHeight),
            self.addButton.widthAnchor.constraint(equalTo: self.addButton.heightAnchor),
            self.addButton.bottomAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: -LocalConstants.addButtonInsets.bottom)
        ])
    }
    
}
