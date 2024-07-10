//
//  ContactsViewController.swift
//  ContactsApp
//
//  Created by Vadim Sorokolit on 05.06.2024.
//

import Foundation
import UIKit
import SnapKit

class ContactsViewController: UIViewController {
    
    // MARK: - Objects
    
    private struct Constants {
        static let titleLabelFont: UIFont = UIFont(name: "Manrope-ExtraBold", size: 28.0) ?? UIFont.systemFont(ofSize: 28.0)
        static let infoLabelFont: UIFont = UIFont(name: "Manrope-Medium", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
        static let backgroundColor: UIColor = UIColor(hexString: "FFFFFF")
        static let infoLabelBackgroundColor: UIColor = UIColor(hexString: "F0F5FF")
        static let searchBarBackgroundColor: UIColor = UIColor(hexString: "E1E6F0")
        static let addButtonColor: UIColor = UIColor(hexString: "447BF1")
        static let separatorBackgroundColor: UIColor = UIColor(hexString: "E5E5E5")
        static let heightViewLines: CGFloat = 1.0
        static let infoLabelCornerRadius: CGFloat = 5.0
        static let searchBarCornerRadius: CGFloat = 10.0
        static let titleLabelTopPadding: CGFloat = 80.0
        static let defaultPaddingLabels: CGFloat = 30.0
        static let defaultHeightLabels: CGFloat = 40.0
        static let defaultTopInsetLabels: CGFloat = 18.0
        static let addButtonHeight: CGFloat = 70.0
        static let addButtonInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 39.0, right: 27.0)
        static let addButtonShadowOpacity: Float = 0.15
        static let addButtonShadowOffSet: CGSize = CGSize(width: 0.0, height: 4.0)
        static let iconPlusSize: CGSize = CGSize(width: 30.0, height: 30.0)
        static let searchBarPlaceholder = "Search"
        static let infoLabelText = "💡 Swipe to delete contact from list"
        static let addButtonIconName = "plus"
        static let titleLabelText = "Contacts"
    }
    
    // MARK: - Properties
    
    private let contactsViewModel: ContactsViewModel
    private var isSearching: Bool = false
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString(Constants.titleLabelText, comment: "")
        label.textAlignment = .left
        label.font = Constants.titleLabelFont
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = Constants.searchBarPlaceholder
        searchBar.backgroundImage = UIImage()
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.backgroundColor = Constants.searchBarBackgroundColor
        searchBar.layer.cornerRadius = Constants.searchBarCornerRadius
        searchBar.layer.masksToBounds = true
        searchBar.searchTextField.borderStyle = .none
        return searchBar
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = Constants.infoLabelBackgroundColor
        label.layer.cornerRadius = Constants.infoLabelCornerRadius
        label.clipsToBounds = true
        label.text = NSLocalizedString(Constants.infoLabelText, comment: "")
        label.font = Constants.infoLabelFont
        label.textAlignment = .center
        return label
    }()
    
    private lazy var navBarSeparator: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = Constants.separatorBackgroundColor
        return lineView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ContactCell.self, forCellReuseIdentifier: ContactCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Constants.addButtonColor
        button.tintColor = Constants.backgroundColor
        if let plusImage = UIImage(named: Constants.addButtonIconName) {
            let image = plusImage.resized(to: Constants.iconPlusSize)
            button.setImage(image, for: .normal)
        }
        button.layer.cornerRadius = Constants.addButtonHeight / 2
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = Constants.addButtonShadowOpacity
        button.layer.shadowOffset = Constants.addButtonShadowOffSet
        return button
    }()
    
    private lazy var headerContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    // MARK: - Initializer
    
    required init(contactsViewModel: ContactsViewModel) {
        self.contactsViewModel = contactsViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(GlobalConstants.fatalError)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.contactsViewModel.deleteAllContacts()
        self.contactsViewModel.fetchContacts()
        if self.contactsViewModel.contacts.isEmpty {
            self.contactsViewModel.testCreateContacts()
        } else {
            print("Database doesn't empty")
        }
        self.setup()
    }
    
    // MARK: - Methods
    
    private func setup() {
        self.setupViews()
    }
    
    private func setupViews() {
        self.view.backgroundColor = Constants.backgroundColor
        self.view.addSubview(self.headerContainerView)
        
        self.headerContainerView.addSubview(self.titleLabel)
        self.headerContainerView.addSubview(self.searchBar)
        self.headerContainerView.addSubview(self.infoLabel)
        
        self.view.addSubview(self.navBarSeparator)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.addButton)
        
        self.headerContainerView.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.view.snp.top).inset(Constants.titleLabelTopPadding)
            make.leading.trailing.equalTo(self.view).inset(Constants.defaultPaddingLabels)
        })
        
        self.titleLabel.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.headerContainerView.snp.top)
            make.leading.trailing.equalTo(self.headerContainerView)
            make.height.equalTo(Constants.defaultHeightLabels)
        })
        
        self.searchBar.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.titleLabel.snp.bottom).inset(-Constants.defaultTopInsetLabels / 1.3)
            make.leading.trailing.equalTo(self.headerContainerView)
            make.height.equalTo(Constants.defaultHeightLabels)
        })
        
        self.infoLabel.snp.makeConstraints({ (make: ConstraintMaker) -> Void  in
            make.top.equalTo(self.searchBar.snp.bottom).inset(-Constants.defaultTopInsetLabels)
            make.leading.trailing.equalTo(self.headerContainerView)
            make.height.equalTo(Constants.defaultHeightLabels)
            make.bottom.equalTo(self.headerContainerView.snp.bottom)
        })
        
        self.navBarSeparator.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.headerContainerView.snp.bottom).inset(-Constants.defaultTopInsetLabels)
            make.leading.trailing.equalTo(self.view)
            make.height.equalTo(Constants.heightViewLines)
        })
        
        self.tableView.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.navBarSeparator.snp.bottom)
            make.leading.trailing.equalTo(self.view)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        })
        
        self.addButton.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.trailing.equalTo(self.view.snp.trailing).inset(Constants.addButtonInsets.right)
            make.height.equalTo(Constants.addButtonHeight)
            make.width.equalTo(Constants.addButtonHeight)
            make.bottom.equalTo(self.tableView.snp.bottom).inset(Constants.addButtonInsets.bottom)
        })
    }
    
}

// MARK: - UISearchBarDelegate

extension ContactsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 3 {
            self.isSearching = true
            contactsViewModel.searchContacts(byQuery: searchText)
        } else {
            self.isSearching = false
            self.contactsViewModel.filteredContacts.removeAll()
        }
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.isSearching = false
        self.contactsViewModel.filteredContacts.removeAll()
        self.tableView.reloadData()
    }
    
}

// MARK: - UITableViewDelegate

extension ContactsViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource

extension ContactsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contactsViewModel.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.reuseID, for: indexPath) as? ContactCell else {
            return UITableViewCell()
        }
        
        let contact = self.contactsViewModel.contacts[indexPath.row]
        cell.setupCell(with: contact)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
