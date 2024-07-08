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
        static let infoLabelBackgroundColor: UIColor = UIColor(hexString: "F0F5FF")
        static let lineViewHeight: CGFloat = 1.0
        static let infoLabelCornerRadius: CGFloat = 5.0
        static let titleLabelTopPadding: CGFloat = 80.0
        static let defaultPaddingLabels: CGFloat = 30.0
        static let defaultHeightLabels: CGFloat = 40.0
        static let defaultTopInsetLabels: CGFloat = 15.0
        static let addButtonHeight: CGFloat = 70.0
        static let addButtonInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 39.0, right: 27.0)
        static let addButtonShadowOpacity: Float = 0.15
        static let addButtonShadowOffSet: CGSize = CGSize(width: 0.0, height: 4.0)
        static let plusSize: CGSize = CGSize(width: 30.0, height: 30.0)
        static let searchBarPlaceholder = "Search"
        static let infoLabelText = "💡 Swipe to delete contact from list"
        static let addButtonAssetsIconName = "plus"
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
    
    private lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .black
        return lineView
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = LocalConstants.infoLabelBackgroundColor
        label.layer.cornerRadius = LocalConstants.infoLabelCornerRadius
        label.clipsToBounds = true
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
        if let plusImage = UIImage(named: LocalConstants.addButtonAssetsIconName) {
            let image = plusImage.resized(to: LocalConstants.plusSize)
            button.setImage(image, for: .normal)
        }
        button.layer.cornerRadius = LocalConstants.addButtonHeight / 2
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = LocalConstants.addButtonShadowOpacity
        button.layer.shadowOffset = LocalConstants.addButtonShadowOffSet
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
        self.view.addSubview(self.lineView)
        self.view.addSubview(self.infoLabel)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.addButton)
        
        self.titleLabel.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.view.snp.top).inset(LocalConstants.titleLabelTopPadding)
            make.leading.trailing.equalTo(self.view).inset(LocalConstants.defaultPaddingLabels)
            make.height.equalTo(LocalConstants.defaultHeightLabels)
        })
        
        self.searchBar.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.titleLabel.snp.bottom).inset(-LocalConstants.defaultTopInsetLabels / 6.0)
            make.leading.trailing.equalTo(self.view).inset(LocalConstants.defaultPaddingLabels - CGFloat(LocalConstants.searchBarPlaceholder.count))
            make.height.equalTo(LocalConstants.defaultHeightLabels)
        })
        
        self.lineView.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.searchBar.snp.bottom).inset(-LocalConstants.defaultTopInsetLabels)
            make.leading.trailing.equalTo(self.view)
            make.height.equalTo(LocalConstants.lineViewHeight)
        })
        
        self.infoLabel.snp.makeConstraints({ (make: ConstraintMaker) -> Void  in
            make.top.equalTo(self.lineView.snp.bottom).inset(-LocalConstants.defaultTopInsetLabels)
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
