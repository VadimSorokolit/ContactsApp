//
//  ContactsViewController.swift
//  ContactsApp
//
//  Created by Vadim Sorokolit on 05.06.2024.
//

import UIKit

class ContactsViewController: UIViewController, UISearchResultsUpdating {
    
    // MARK: - Objects
    
    private struct LocalConstants {
        static let defaultWidth: CGFloat = 30.0
        static let defaultHeight: CGFloat = 40.0
    }
    
    // MARK: - Properties

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.hidesNavigationBarDuringPresentation = false
        return searchController
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
        titleLabel.text = NSLocalizedString("Contacts", comment: "")
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
            titleContainerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - LocalConstants.defaultWidth * 2)
        ])
        
        self.navigationItem.titleView = titleContainerView
    }
    
    private func setupViews() {
        self.view.backgroundColor = .gray
    }
    
    private func setupSearchController() {
        self.navigationItem.searchController = self.searchController
        self.definesPresentationContext = true
        
        if let searchBarTextField = self.searchController.searchBar.value(forKey: "searchField") as? UITextField {
            searchBarTextField.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                searchBarTextField.leadingAnchor.constraint(equalTo: self.searchController.searchBar.leadingAnchor, constant: LocalConstants.defaultWidth),
                searchBarTextField.trailingAnchor.constraint(equalTo: self.searchController.searchBar.trailingAnchor, constant: -LocalConstants.defaultWidth),
                searchBarTextField.heightAnchor.constraint(equalToConstant: LocalConstants.defaultHeight)
            ])
        }
        
        self.searchController.searchBar.showsCancelButton = false
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            print(searchText)
        }
    }
        
}
