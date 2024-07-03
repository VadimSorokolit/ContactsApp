//
//  ContactsViewController.swift
//  ContactsApp
//
//  Created by Vadim Sorokolit on 05.06.2024.
//

import UIKit

class ContactsViewController: UIViewController {
    
    // MARK: - Objects
    
    private struct LocalConstants {
        static let contactsScreenBackgroundColor: UIColor = UIColor(hexString: "FFFFFF")
        static let contactsScreenAddButtonColor: UIColor = UIColor(hexString: "447BF1")
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
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = LocalConstants.searchBarPlaceholder
        searchController.hidesNavigationBarDuringPresentation = false
        return searchController
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString(LocalConstants.infoLabeltext, comment: "")
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = LocalConstants.contactsScreenBackgroundColor
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
        self.setupNavBar()
        self.setupSearchController()
        self.setupViews()
    }
    
    private func setupNavBar() {
        self.navigationItem.largeTitleDisplayMode = .always
        
        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString(LocalConstants.titleLabelText, comment: "")
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 28.0, weight: .bold)
        
        let titleContainerView = UIView()
        titleContainerView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: titleContainerView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: titleContainerView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor),
            titleContainerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - LocalConstants.labelPadding * 2)
        ])
        self.navigationItem.titleView = titleContainerView
    }
    
    private func setupViews() {
        self.view.backgroundColor = LocalConstants.contactsScreenBackgroundColor
        self.view.addSubview(self.infoLabel)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.addButton)
        
        NSLayoutConstraint.activate([
            self.infoLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: LocalConstants.labelPadding),
            self.infoLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -LocalConstants.labelPadding),
            self.infoLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
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

    private func setupSearchController() {
        self.navigationItem.searchController = self.searchController
        self.definesPresentationContext = true
        
        if let searchBarTextField = self.searchController.searchBar.value(forKey: "searchField") as? UITextField {
            searchBarTextField.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                searchBarTextField.leadingAnchor.constraint(equalTo: self.searchController.searchBar.leadingAnchor, constant: LocalConstants.labelPadding),
                searchBarTextField.trailingAnchor.constraint(equalTo: self.searchController.searchBar.trailingAnchor, constant: -LocalConstants.labelPadding),
                searchBarTextField.heightAnchor.constraint(equalToConstant: LocalConstants.heightLabels)
            ])
        }
        self.searchController.searchBar.showsCancelButton = false
    }
    
}

// MARK: - UISearchResultsUpdating

extension ContactsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            print(searchText)
        }
    }
    
}
