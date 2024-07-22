//
//  EditContactController.swift
//  ContactsApp
//
//  Created by Vadim Sorokolit on 16.07.2024.
//

import Foundation
import UIKit
import SnapKit

class EditContactViewController: UIViewController {
    
    // MARK: - Objects
    
    private struct Constants {
        static let photoLabelFont: UIFont? = UIFont(name: "Manrope-Bold", size: 14.0)
        static let saveButtonFont: UIFont? = UIFont(name: "Manrope-Bold", size: 24.0)
        static let titleLabelFont: UIFont? = UIFont(name: "Manrope-Bold", size: 28.0)
        static let backgroundColor: UIColor = UIColor(hexString: "447BF1")
        static let textColor: UIColor = UIColor(hexString: "FFFFFF")
        static let saveButtonBackgroundColor: UIColor = UIColor(hexString: "FFFFFF")
        static let saveButtonTitleColor: UIColor = UIColor(hexString: "447BF1")
        static let separatorBackgroundColor: UIColor = UIColor(hexString: "FFFFFF")
        static let addPhotoIconName: String = "addPhoto"
        static let backButtonIconName: String = "x"
        static let photoLabelTitle: String = "Photo"
        static let saveButtonTitle: String = "Save contact"
        static let nameTextFieldTitle: String = "Full name"
        static let jobPositionTextFieldTitle = "Job position"
        static let emailTextFieldTitle = "Email"
        static let nameTextFieldPlaceholder = "Enter name"
        static let jobPositionTextFieldPlaceholder = "Enter position"
        static let emailTextFieldPlaceholder = "Enter email"
        static let addPhotoButtonSize: CGSize = CGSize(width: 143.0, height: 143.0)
        static let addPhotoButtonHeight: CGFloat = 143.0
        static let addPhotoButtonTopPadding: CGFloat = 12.0
        static let backButtonInsets: UIEdgeInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: 34.0)
        static let backButtonSize: CGSize = CGSize(width: 33.0, height: 33.0)
        static let backButtonIconSize: CGSize = CGSize(width: 19.25, height: 19.25)
        static let backButtonImagePadding: CGFloat = 6.87
        static let defaultLabelsPadding: CGFloat = 30.0
        static let photoLabelHeight: CGFloat = 19.0
        static let photoLabelTopPadding: CGFloat = 50.0
        static let saveButtonBottomInset: CGFloat = 59.0
        static let saveButtonCornerRadius: CGFloat = 10.0
        static let saveButtonHeight: CGFloat = 69.0
        static let saveButtonTopPadding: CGFloat = 81.0
        static let separatorHeight: CGFloat = 1.0
        static let separatorTopInset: CGFloat = 23.0
        static let stackViewSpacing: CGFloat = 50.0
        static let stackViewTopPadding: CGFloat = 59.0
        static let titleLabelHeight: CGFloat = 38.0
        static let titleLabelTopPadding: CGFloat = 97.0
    }
    
    // MARK: - Properties
    
    private let contactsViewModel: ContactsViewModel
    private let titleLabelText: String
    private let contact: Contact?
    
    private var statusBarHeight: CGFloat {
        var height: CGFloat = .zero
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            height = windowScene.statusBarManager?.statusBarFrame.height ?? .zero
        }
        
        return height
    }
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        
        if let xImage = UIImage(named: Constants.backButtonIconName) {
            let increasedSize = CGSize(width: Constants.backButtonIconSize.width + (2.0 * Constants.backButtonImagePadding),
                                       height: Constants.backButtonIconSize.height + (2.0 * Constants.backButtonImagePadding))
            let image = xImage.resized(to: increasedSize)
            
            button.setImage(image, for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
        }
        
        button.addTarget(self, action: #selector(self.onBackButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString(self.titleLabelText, comment: "")
        label.font = Constants.titleLabelFont
        label.textColor = Constants.textColor
        return label
    }()
    
    private lazy var separator: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = Constants.separatorBackgroundColor
        return lineView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    private lazy var textFieldWithTitleName: TextFieldWithTitle = {
        let textFieldWithTitle = TextFieldWithTitle()
        textFieldWithTitle.configure(title: Constants.nameTextFieldTitle, placeholder: Constants.nameTextFieldPlaceholder)
        return textFieldWithTitle
    }()

    private lazy var textFieldWithTitleJobPosition: TextFieldWithTitle = {
        let textFieldWithTitle = TextFieldWithTitle()
        textFieldWithTitle.configure(title: Constants.jobPositionTextFieldTitle, placeholder: Constants.jobPositionTextFieldPlaceholder)
        return textFieldWithTitle
    }()
    
    private lazy var textFieldWithTitleEmail: TextFieldWithTitle = {
        let textFieldWithTitle = TextFieldWithTitle()
        textFieldWithTitle.configure(title: Constants.emailTextFieldTitle, placeholder: Constants.emailTextFieldPlaceholder)
        return textFieldWithTitle
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewSpacing
        return stackView
    }()
    
    private lazy var labelPhoto: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString(Constants.photoLabelTitle, comment: "")
        label.font = Constants.photoLabelFont
        label.textColor = Constants.textColor
        return label
    }()
    
    private lazy var addPhotoView: UIImageView = {
        let imageView = UIImageView()
        
        if let addPhotoImage = UIImage(named: Constants.addPhotoIconName) {
            let image = addPhotoImage.resized(to: Constants.addPhotoButtonSize)
            imageView.image = image
        }
        
        imageView.layer.cornerRadius = Constants.addPhotoButtonHeight / 2.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Constants.saveButtonBackgroundColor
        button.layer.cornerRadius = Constants.saveButtonCornerRadius
        button.setTitle(Constants.saveButtonTitle, for: .normal)
        button.setTitleColor(Constants.saveButtonTitleColor, for: .normal)
        button.titleLabel?.font = Constants.saveButtonFont
        button.addTarget(self, action: #selector(self.onSaveButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initializer
    
    required init(contactsViewModel: ContactsViewModel, title: String, contact: Contact?) {
        self.contactsViewModel = contactsViewModel
        self.titleLabelText = title
        self.contact = contact
        
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
        self.setupTextFields()
    }
    
    private func setupViews() {
        self.view.backgroundColor = Constants.backgroundColor
        
        self.stackView.addArrangedSubview(self.textFieldWithTitleName)
        self.stackView.addArrangedSubview(self.textFieldWithTitleJobPosition)
        self.stackView.addArrangedSubview(self.textFieldWithTitleEmail)
        
        self.containerView.addSubview(self.stackView)
        self.containerView.addSubview(self.labelPhoto)
        self.containerView.addSubview(self.addPhotoView)
        self.containerView.addSubview(self.saveButton)
        
        self.scrollView.addSubview(self.containerView)
        
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.separator)
        self.view.addSubview(self.scrollView)
        
        self.backButton.snp.makeConstraints( { (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.view.snp.top).offset(self.statusBarHeight + Constants.backButtonInsets.top)
            make.trailing.equalTo(self.view.snp.trailing).inset(Constants.backButtonInsets.right)
            make.size.equalTo(Constants.backButtonSize)
        })
        
        self.titleLabel.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.view.snp.top).offset(Constants.titleLabelTopPadding)
            make.leading.trailing.equalTo(self.view).inset(Constants.defaultLabelsPadding)
            make.height.equalTo(Constants.titleLabelHeight)
        })
        
        self.separator.snp.makeConstraints( { (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Constants.separatorTopInset)
            make.leading.trailing.equalTo(self.titleLabel)
            make.height.equalTo(Constants.separatorHeight)
        })
        
        self.scrollView.snp.makeConstraints( { (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.separator.snp.bottom)
            make.leading.trailing.bottom.equalTo(self.view)
        })
        
        self.containerView.snp.makeConstraints( { (make: ConstraintMaker) -> Void in
            make.edges.equalTo(self.scrollView.snp.edges)
            make.width.equalTo(self.scrollView.snp.width)
        })
        
        self.stackView.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.containerView.snp.top).offset(Constants.stackViewTopPadding)
            make.leading.trailing.equalTo(self.containerView).inset(Constants.defaultLabelsPadding)
        })
        
        self.labelPhoto.snp.makeConstraints( { (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.stackView.snp.bottom).offset(Constants.photoLabelTopPadding)
            make.leading.trailing.equalTo(self.titleLabel)
            make.height.equalTo(Constants.photoLabelHeight)
        })
        
        self.addPhotoView.snp.makeConstraints( { (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.labelPhoto.snp.bottom).offset(Constants.addPhotoButtonTopPadding)
            make.leading.equalTo(self.containerView.snp.leading).inset(Constants.defaultLabelsPadding)
            make.size.equalTo(Constants.addPhotoButtonSize)
        })
        
        self.saveButton.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.addPhotoView.snp.bottom).offset(Constants.saveButtonTopPadding)
            make.leading.trailing.equalTo(self.containerView).inset(Constants.defaultLabelsPadding)
            make.height.equalTo(Constants.saveButtonHeight)
            make.bottom.equalTo(self.containerView.snp.bottom).inset(Constants.saveButtonBottomInset)
        })
    }
    
    private func setupTextFields() {
        if let contact = self.contact {
            self.textFieldWithTitleName.text = contact.fullName
            self.textFieldWithTitleJobPosition.text = contact.jobPosition
            self.textFieldWithTitleEmail.text = contact.email
            self.addPhotoView.image = contact.photo ?? UIImage(named: Constants.addPhotoIconName)
        }
    }
    
    // MARK: - Events
    
    @objc private func onBackButtonDidTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func onSaveButtonDidTap() {}
    
}
