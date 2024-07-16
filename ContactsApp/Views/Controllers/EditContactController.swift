//
//  EditContactController.swift
//  ContactsApp
//
//  Created by Vadim Sorokolit on 16.07.2024.
//

import Foundation
import UIKit
import SnapKit

class EditContactController: UIViewController {
    
    // MARK: - Objects
    
    private struct Constants {
        static let titleLabelFont: UIFont? = UIFont(name: "Manrope-ExtraBold", size: 28.0)
        static let saveButtonTitleFont: UIFont? = UIFont(name: "Manrope-ExtraBold", size: 24.0)
        static let backgroundColor: UIColor = UIColor(hexString: "447BF1")
        static let defaultColor: UIColor = UIColor(hexString: "FFFFFF")
        static let defaultLabelsPadding: CGFloat = 30.0
        static let goToBackButtonInsets: UIEdgeInsets = UIEdgeInsets(top: 44.0, left: 0.0, bottom: 0.0, right: 34.0)
        static let separatorTopInset: CGFloat = 23.0
        static let saveButtonBottomInset: CGFloat = 59.0
        static let saveButtonHeight: CGFloat = 69.0
        static let saveButtonCornerRadius: CGFloat = 10.0
        static let separatorHeight: CGFloat = 1.0
        static let defaultLabelsHeight: CGFloat = 40.0
        static let goToBackButtonSize: CGSize = CGSize(width: 33.0, height: 33.0)
        static let titleLabelText: String = "New Contact"
        static let saveButtonTitle: String = "Save contact"
        static let goToBackButtonIconName: String = "x"
    }
    
    // MARK: - Properties
    
    private let contactsViewModel: ContactsViewModel
    
    private lazy var goToBackButton: UIButton = {
        let button = UIButton()
        if let xImage = UIImage(named: Constants.goToBackButtonIconName) {
            let image = xImage.resized(to: Constants.goToBackButtonSize)
            button.setImage(image, for: .normal)
        }
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString(Constants.titleLabelText, comment: "")
        label.font = Constants.titleLabelFont
        label.textColor = Constants.defaultColor
        return label
    }()
    
    private lazy var separator: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = Constants.defaultColor
        return lineView
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Constants.defaultColor
        button.layer.cornerRadius = Constants.saveButtonCornerRadius
        button.setTitle(Constants.saveButtonTitle, for: .normal)
        button.setTitleColor(Constants.backgroundColor, for: .normal)
        button.titleLabel?.font = Constants.saveButtonTitleFont
        return button
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
    }
    
    private func setupViews() {
        self.view.backgroundColor = Constants.backgroundColor
        
        self.view.addSubview(self.goToBackButton)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.separator)
        self.view.addSubview(self.saveButton)
        
        self.goToBackButton.snp.makeConstraints( { (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.view.snp.top).offset(Constants.goToBackButtonInsets.top)
            make.trailing.equalTo(self.view.snp.trailing).inset(Constants.goToBackButtonInsets.right)
            make.size.equalTo(Constants.goToBackButtonSize)
        })
        
        self.titleLabel.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.view.snp.top).offset(72.0)
            make.leading.trailing.equalTo(self.view).inset(Constants.defaultLabelsPadding)
            make.height.equalTo(Constants.defaultLabelsHeight)
        })
        
        
        self.separator.snp.makeConstraints( { (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Constants.separatorTopInset)
            make.leading.trailing.equalTo(self.titleLabel)
            make.height.equalTo(Constants.separatorHeight)
        })
        
        self.saveButton.snp.makeConstraints( { (make: ConstraintMaker) -> Void in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-Constants.defaultLabelsHeight)
            make.leading.trailing.equalTo(self.titleLabel)
            make.height.equalTo(Constants.saveButtonHeight)
        })
    }
    
}
