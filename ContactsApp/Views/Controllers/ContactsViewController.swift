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
        static let addButtonColor: UIColor = UIColor(hexString: "447BF1")
        static let infoLabelBackgroundColor: UIColor = UIColor(hexString: "F0F5FF")
        static let lineViewBackgroundColor: UIColor = UIColor(hexString: "e5e5e5")
        static let lineViewHeight: CGFloat = 1.0
        static let infoLabelCornerRadius: CGFloat = 5.0
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
        static let addButtonAssetsIconName = "plus"
        static let titleLabelText = "Contacts"
    }
    
    // MARK: - Properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString(Constants.titleLabelText, comment: "")
        label.textAlignment = .left
        label.font = Constants.titleLabelFont
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = Constants.searchBarPlaceholder
        searchBar.backgroundImage = UIImage()
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        return searchBar
    }()
    
    private lazy var navBarLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = Constants.lineViewBackgroundColor
        return lineView
    }()
    
    private lazy var tableViewlineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = Constants.lineViewBackgroundColor
        return lineView
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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Constants.addButtonColor
        button.tintColor = Constants.backgroundColor
        if let plusImage = UIImage(named: Constants.addButtonAssetsIconName) {
            let image = plusImage.resized(to: Constants.iconPlusSize)
            button.setImage(image, for: .normal)
        }
        button.layer.cornerRadius = Constants.addButtonHeight / 2
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = Constants.addButtonShadowOpacity
        button.layer.shadowOffset = Constants.addButtonShadowOffSet
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
        self.view.backgroundColor = Constants.backgroundColor
        
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.navBarLineView)
        self.view.addSubview(self.infoLabel)
        self.view.addSubview(self.tableViewlineView)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.addButton)
        
        self.titleLabel.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.view.snp.top).inset(Constants.titleLabelTopPadding)
            make.leading.trailing.equalTo(self.view).inset(Constants.defaultPaddingLabels)
            make.height.equalTo(Constants.defaultHeightLabels)
        })
        
        self.searchBar.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.titleLabel.snp.bottom).inset(-Constants.defaultTopInsetLabels / 1.3)
            make.leading.trailing.equalTo(self.view).inset(Constants.defaultPaddingLabels - CGFloat(Constants.searchBarPlaceholder.count) - 2.0)
            make.height.equalTo(Constants.defaultHeightLabels)
        })
        
        self.navBarLineView.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.searchBar.snp.bottom).inset(-Constants.defaultTopInsetLabels)
            make.leading.trailing.equalTo(self.view)
            make.height.equalTo(Constants.lineViewHeight)
        })
        
        self.infoLabel.snp.makeConstraints({ (make: ConstraintMaker) -> Void  in
            make.top.equalTo(self.navBarLineView.snp.bottom).inset(-Constants.defaultTopInsetLabels)
            make.leading.trailing.equalTo(self.view).inset(Constants.defaultPaddingLabels)
            make.height.equalTo(Constants.defaultHeightLabels)
        })
        
        self.tableViewlineView.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.infoLabel.snp.bottom).inset(-Constants.defaultTopInsetLabels)
            make.leading.trailing.equalTo(self.view)
            make.height.equalTo(Constants.lineViewHeight)
        })
        
        self.tableView.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.tableViewlineView.snp.bottom).inset(-Constants.defaultTopInsetLabels)
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
