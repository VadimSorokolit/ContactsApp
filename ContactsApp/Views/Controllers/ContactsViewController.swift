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
    
    private struct LocalConstants {
        static let titleLabelFont: UIFont = UIFont(name: "Manrope-ExtraBold", size: 28.0) ?? UIFont.systemFont(ofSize: 28.0)
        static let infoLabelFont: UIFont = UIFont(name: "Manrope-Medium", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
        static let backgroundColor: UIColor = UIColor(hexString: "FFFFFF")
        static let addButtonColor: UIColor = UIColor(hexString: "447BF1")
        static let titleLabelTopPadding: CGFloat = 80.0
        static let defaultPaddingLabels: CGFloat = 30.0
        static let defaultHeightLabels: CGFloat = 40.0
        static let addButtonHeight: CGFloat = 70.0
        static let addButtonInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 39.0, right: 27.0)
        static let searchBarPlaceholder = "Search"
        static let infoLabelText = "💡 Swipe to delete contact from list"
        static let addButtonIconName = "plus"
        static let titleLabelText = "Contacts"
    }
    
    // MARK: - Properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString(LocalConstants.titleLabelText, comment: "")
        label.textAlignment = .left
        label.font = LocalConstants.titleLabelFont
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = LocalConstants.searchBarPlaceholder
        searchBar.backgroundImage = UIImage()
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        return searchBar
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString(LocalConstants.infoLabelText, comment: "")
        label.font = LocalConstants.infoLabelFont
        label.textAlignment = .center
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = LocalConstants.addButtonColor
        button.tintColor = LocalConstants.backgroundColor
        button.setImage(UIImage(systemName: LocalConstants.addButtonIconName), for: .normal)
        button.layer.cornerRadius = LocalConstants.addButtonHeight / 2
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
        self.view.backgroundColor = LocalConstants.backgroundColor
        
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.infoLabel)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.addButton)
        
        self.titleLabel.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.view.snp.top).inset(LocalConstants.titleLabelTopPadding)
            make.leading.trailing.equalTo(self.view).inset(LocalConstants.defaultPaddingLabels)
            make.height.equalTo(LocalConstants.defaultHeightLabels)
        })
        
        self.searchBar.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.titleLabel.snp.bottom)
            make.leading.trailing.equalTo(self.view).inset(LocalConstants.defaultPaddingLabels - CGFloat(LocalConstants.searchBarPlaceholder.count))
            make.height.equalTo(LocalConstants.defaultHeightLabels)
        })
        
        self.infoLabel.snp.makeConstraints({ (make: ConstraintMaker) -> Void  in
            make.top.equalTo(self.searchBar.snp.bottom)
            make.leading.trailing.equalTo(self.view).inset(LocalConstants.defaultPaddingLabels)
            make.height.equalTo(LocalConstants.defaultHeightLabels)
        })
        
        self.tableView.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.infoLabel.snp.bottom)
            make.leading.trailing.equalTo(self.view)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        })
        
        self.addButton.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.trailing.equalTo(self.view.snp.trailing).inset(LocalConstants.addButtonInsets.right)
            make.height.equalTo(LocalConstants.addButtonHeight)
            make.width.equalTo(LocalConstants.addButtonHeight)
            make.bottom.equalTo(self.tableView.snp.bottom).inset(LocalConstants.addButtonInsets.bottom)
        })
    }
    
}
