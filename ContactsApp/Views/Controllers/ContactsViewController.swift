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
        static let titleLabelFont: UIFont? = UIFont(name: "Manrope-ExtraBold", size: 28.0)
        static let infoLabelFont: UIFont? = UIFont(name: "Manrope-Medium", size: 14.0)
        static let backgroundColor: UIColor = UIColor(hexString: "FFFFFF")
        static let infoLabelBackgroundColor: UIColor = UIColor(hexString: "F0F5FF")
        static let searchBarBackgroundColor: UIColor = UIColor(hexString: "E1E6F0")
        static let addButtonColor: UIColor = UIColor(hexString: "447BF1")
        static let separatorBackgroundColor: UIColor = UIColor(hexString: "E5E5E5")
        static let separatorHeight: CGFloat = 1.0
        static let infoLabelCornerRadius: CGFloat = 5.0
        static let searchBarCornerRadius: CGFloat = 10.0
        static let titleLabelTopPadding: CGFloat = 80.0
        static let defaultLabelsPadding: CGFloat = 30.0
        static let defaultLabelsHeight: CGFloat = 40.0
        static let defaultLabelsTopInset: CGFloat = 18.0
        static let addButtonHeight: CGFloat = 70.0
        static let addButtonInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 39.0, right: 27.0)
        static let addButtonShadowOpacity: Float = 0.15
        static let addButtonShadowOffset: CGSize = CGSize(width: 0.0, height: 4.0)
        static let iconPlusSize: CGSize = CGSize(width: 30.0, height: 30.0)
        static let newContactTitleName: String = "New contact"
        static let editContactTitleName: String = "Edit Contact"
        static let searchBarPlaceholder: String = "Search"
        static let infoLabelText: String = "💡 Swipe to delete contact from list"
        static let addButtonIconName: String = "plus"
        static let titleLabelText: String = "Contacts"
    }
    
    // MARK: - Properties
    
    private let contactsViewModel: ContactsViewModel
    private var isSearching: Bool = false
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString(Constants.titleLabelText, comment: "")
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
        tableView.separatorInset.left = Constants.defaultLabelsPadding
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
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
        button.layer.shadowOffset = Constants.addButtonShadowOffset
        button.addTarget(self, action: #selector(self.onAddButtonDidTap), for: .touchUpInside)
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
        
        self.setup()
    }
    
    // MARK: - Methods
    
    private func setup() {
        self.setupViews()
        self.getData()
    }
    
    private func setupViews() {
        self.view.backgroundColor = Constants.backgroundColor
        
        self.headerContainerView.addSubview(self.titleLabel)
        self.headerContainerView.addSubview(self.searchBar)
        self.headerContainerView.addSubview(self.infoLabel)
        self.headerContainerView.addSubview(self.navBarSeparator)
        
        self.view.addSubview(self.headerContainerView)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.addButton)
        
        self.headerContainerView.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.view.snp.top).offset(Constants.titleLabelTopPadding)
            make.leading.trailing.equalTo(self.view)
        })
        
        self.titleLabel.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.headerContainerView.snp.top)
            make.leading.trailing.equalTo(self.view).inset(Constants.defaultLabelsPadding)
            make.height.equalTo(Constants.defaultLabelsHeight)
        })
        
        self.searchBar.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Constants.defaultLabelsTopInset / 1.3)
            make.leading.trailing.equalTo(self.titleLabel)
            make.height.equalTo(Constants.defaultLabelsHeight)
        })
        
        self.infoLabel.snp.makeConstraints({ (make: ConstraintMaker) -> Void  in
            make.top.equalTo(self.searchBar.snp.bottom).offset(Constants.defaultLabelsTopInset)
            make.leading.trailing.equalTo(self.searchBar)
            make.height.equalTo(Constants.defaultLabelsHeight)
        })
        
        self.navBarSeparator.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.infoLabel.snp.bottom).offset(Constants.defaultLabelsTopInset)
            make.leading.trailing.equalTo(self.view)
            make.height.equalTo(Constants.separatorHeight)
            make.bottom.equalTo(self.headerContainerView.snp.bottom)
        })
        
        self.tableView.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.headerContainerView.snp.bottom)
            make.leading.trailing.equalTo(self.view)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        })
        
        self.addButton.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.trailing.equalTo(self.view.snp.trailing).inset(Constants.addButtonInsets.right)
            make.size.equalTo(Constants.addButtonHeight)
            make.bottom.equalTo(self.tableView.snp.bottom).inset(Constants.addButtonInsets.bottom)
        })
    }
    
    private func getData() {
        // self.contactsViewModel.deleteAllContacts()
        self.contactsViewModel.fetchContacts()
        if self.contactsViewModel.contacts.isEmpty {
            self.contactsViewModel.testCreateContacts()
        } else {
            print("Database doesn't empty")
        }
    }
    
    private func goToEditViewController(withTitleName titleName: String) {
        let editContactController = EditContactViewController(contactsViewModel: self.contactsViewModel, title: titleName)
        editContactController.modalPresentationStyle = .fullScreen
        self.present(editContactController, animated: true, completion: nil)
    }
    
    // MARK: - Events
    
    @objc private func onAddButtonDidTap() {
        self.goToEditViewController(withTitleName: Constants.newContactTitleName)
    }
    
}

// MARK: - UISearchBarDelegate

extension ContactsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 3 {
            self.isSearching = true
            self.contactsViewModel.searchContacts(byQuery: searchText)
        } else {
            self.isSearching = false
        }
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
        self.isSearching = false
        self.tableView.reloadData()
    }
    
}

// MARK: - UITableViewDelegate

extension ContactsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.goToEditViewController(withTitleName: Constants.editContactTitleName)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let editingStyle: UITableViewCell.EditingStyle = .delete
        return editingStyle
    }
    
}

// MARK: - UITableViewDataSource

extension ContactsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let contactsCount = self.contactsViewModel.contacts.count
        return contactsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.reuseID, for: indexPath) as? ContactCell else {
            return UITableViewCell()
        }
        
        let contacts = self.contactsViewModel.contacts
        let contact = contacts[indexPath.row]
        cell.setupCell(with: contact)
        
        let isLastCell = indexPath.row == contacts.count - 1
        
        if isLastCell {
            cell.hideSeparator()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let contactToRemove = self.contactsViewModel.contacts[indexPath.row]
        
        if let contactEmail = contactToRemove.email, editingStyle == .delete {
            self.contactsViewModel.deleteContact(byEmail: contactEmail)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}


