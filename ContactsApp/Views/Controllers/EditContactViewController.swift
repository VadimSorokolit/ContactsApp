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
        static let topTitleLabelFont: UIFont? = UIFont(name: "Manrope-Bold", size: 28.0)
        static let saveButtonTitleFont: UIFont? = UIFont(name: "Manrope-Bold", size: 24.0)
        static let titleLabelPhotoFont: UIFont? = UIFont(name: "Manrope-Bold", size: 14.0)
        static let backgroundColor: UIColor = UIColor(hexString: "447BF1")
        static let defaultColor: UIColor = UIColor(hexString: "FFFFFF")
        static let defaultLabelsPadding: CGFloat = 30.0
        static let goToBackButtonInsets: UIEdgeInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: 34.0)
        static let goToBackButtonImagePadding: CGFloat = 6.87
        static let titleLabelTopPadding: CGFloat = 72.0
        static let stackViewTopPadding: CGFloat = 40.0
        static let separatorTopInset: CGFloat = 23.0
        static let saveButtonBottomInset: CGFloat = 59.0
        static let saveButtonHeight: CGFloat = 69.0
        static let saveButtonCornerRadius: CGFloat = 10.0
        static let separatorHeight: CGFloat = 1.0
        static let defaultLabelsHeight: CGFloat = 40.0
        static let stackViewSpacing: CGFloat = 30.0
        static let isZero: CGFloat = 0.0
        static let goToBackButtonSize: CGSize = CGSize(width: 33.0, height: 33.0)
        static let goToBackButtonIconSize: CGSize = CGSize(width: 19.25, height: 19.25)
        static let iconAddPhotoSize: CGSize = CGSize(width: 143.0, height: 143.0)
        static let addPhotoButtonHeight: CGFloat = 143.0
        static let addPhotoButtonTopPadding: CGFloat = 12.0
        static let titleLabelPhotoHeight: CGFloat = 19.0
        static let titleLabelPhotoTopPadding: CGFloat = 50.0
        static let saveButtonTopPadding: CGFloat = 81.0
        static let addPhoIconName: String = "addPhoto"
        static let topTitleLabelText: String = "New contact"
        static let bottomTitleLabelText: String = "Photo"
        static let saveButtonTitle: String = "Save contact"
        static let goToBackButtonIconName: String = "x"
        static let nameTextFieldWithTitleName = "Full name"
        static let textFieldWithTitleNamePlaceholder = "Enter name"
        static let nameTextFieldWithTitleJob = "Job position"
        static let textFieldWithTitleJobPlaceholder = "Enter position"
        static let nameTextFieldWithTitleEmail = "Email"
        static let textFieldWithTitleEmailPlaceholder = "Enter email"
    }
    
    // MARK: - Properties
    
    private let contactsViewModel: ContactsViewModel
    
    private var statusBarHeight: CGFloat {
        var height: CGFloat = Constants.isZero
        
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                height = windowScene.statusBarManager?.statusBarFrame.height ?? Constants.isZero
            }
        } else {
            height = UIApplication.shared.statusBarFrame.height
        }
        
        return height
    }
    
    private lazy var goToBackButton: UIButton = {
        let button = UIButton()
        if let xImage = UIImage(named: Constants.goToBackButtonIconName) {
            let image = xImage.resized(to: Constants.goToBackButtonSize)
            button.configuration?.imagePadding = Constants.goToBackButtonImagePadding
            button.setImage(image, for: .normal)
        }
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString(Constants.topTitleLabelText, comment: "")
        label.font = Constants.topTitleLabelFont
        label.textColor = Constants.defaultColor
        return label
    }()
    
    private lazy var separator: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = Constants.defaultColor
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
        textFieldWithTitle.configure(title: Constants.nameTextFieldWithTitleName, placeholder: Constants.textFieldWithTitleNamePlaceholder)
        return textFieldWithTitle
    }()

    private lazy var textFieldWithTitleJobPosition: TextFieldWithTitle = {
        let textFieldWithTitle = TextFieldWithTitle()
        textFieldWithTitle.configure(title: Constants.nameTextFieldWithTitleJob, placeholder: Constants.textFieldWithTitleJobPlaceholder)
        return textFieldWithTitle
    }()
    
    private lazy var textFieldWithTitleEmail: TextFieldWithTitle = {
        let textFieldWithTitle = TextFieldWithTitle()
        textFieldWithTitle.configure(title: Constants.nameTextFieldWithTitleEmail, placeholder: Constants.textFieldWithTitleEmailPlaceholder)
        return textFieldWithTitle
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewSpacing
        return stackView
    }()
    
    private lazy var titleLabelPhoto: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString(Constants.bottomTitleLabelText, comment: "")
        label.font = Constants.titleLabelPhotoFont
        label.textColor = Constants.defaultColor
        return label
    }()
    
    private lazy var addPhotoButton: UIButton = {
        let button = UIButton()
        if let addPhotoImage = UIImage(named: Constants.addPhoIconName) {
            let image = addPhotoImage.resized(to: Constants.iconAddPhotoSize)
            button.setImage(image, for: .normal)
        }
        button.layer.cornerRadius = Constants.addPhotoButtonHeight / 2
        button.layer.shadowColor = UIColor.black.cgColor
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Constants.defaultColor
        button.layer.cornerRadius = Constants.saveButtonCornerRadius
        button.setTitle(Constants.saveButtonTitle, for: .normal)
        button.setTitleColor(Constants.backgroundColor, for: .normal)
        button.titleLabel?.font = Constants.saveButtonTitleFont
        button.addTarget(self, action: #selector(self.onSaveButtonDidTap), for: .touchUpInside)
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
        
        self.stackView.addArrangedSubview(self.textFieldWithTitleName)
        self.stackView.addArrangedSubview(self.textFieldWithTitleJobPosition)
        self.stackView.addArrangedSubview(self.textFieldWithTitleEmail)
        
        self.containerView.addSubview(self.stackView)
        self.containerView.addSubview(self.titleLabelPhoto)
        self.containerView.addSubview(self.addPhotoButton)
        self.containerView.addSubview(self.saveButton)
        
        self.scrollView.addSubview(containerView)
        
        
        self.view.addSubview(self.goToBackButton)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.separator)
        self.view.addSubview(self.scrollView)
        
        self.goToBackButton.snp.makeConstraints( { (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.view.snp.top).offset(self.statusBarHeight + Constants.goToBackButtonInsets.top)
            make.trailing.equalTo(self.view.snp.trailing).inset(Constants.goToBackButtonInsets.right)
            make.size.equalTo(Constants.goToBackButtonSize)
        })
        
        self.titleLabel.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.view.snp.top).offset(Constants.titleLabelTopPadding)
            make.leading.trailing.equalTo(self.view).inset(Constants.defaultLabelsPadding)
            make.height.equalTo(Constants.defaultLabelsHeight)
        })
        
        self.separator.snp.makeConstraints( { (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Constants.separatorTopInset)
            make.leading.trailing.equalTo(self.titleLabel)
            make.height.equalTo(Constants.separatorHeight)
        })
    
        self.scrollView.snp.makeConstraints( { (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.separator.snp.bottom)
            make.leading.trailing.equalTo(self.view)
            make.bottom.equalTo(self.view.snp.bottom)
        })
        
        self.containerView.snp.makeConstraints( { (make: ConstraintMaker) -> Void in
            make.edges.equalTo(self.scrollView)
            make.width.equalTo(self.scrollView)
        })
        
        self.stackView.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.containerView.snp.top).offset(Constants.stackViewTopPadding)
            make.leading.trailing.equalToSuperview().inset(Constants.defaultLabelsPadding)
        })
        
        self.titleLabelPhoto.snp.makeConstraints( { (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.stackView.snp.bottom).offset(Constants.titleLabelTopPadding)
            make.leading.trailing.equalTo(self.titleLabel)
            make.height.equalTo(Constants.titleLabelPhotoHeight)
        })
        
        self.addPhotoButton.snp.makeConstraints( { (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.titleLabelPhoto.snp.bottom).offset(Constants.addPhotoButtonTopPadding)
            make.leading.equalTo(self.containerView).inset(Constants.defaultLabelsPadding)
        })
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(addPhotoButton.snp.bottom).offset(Constants.saveButtonTopPadding)
            make.leading.trailing.equalToSuperview().inset(Constants.defaultLabelsPadding)
            make.height.equalTo(Constants.saveButtonHeight)
            make.bottom.equalTo(containerView.snp.bottom).offset(-Constants.saveButtonBottomInset)
        }

    }
    
    // MARK: - Events
    
    @objc private func onSaveButtonDidTap() {}
    
}
