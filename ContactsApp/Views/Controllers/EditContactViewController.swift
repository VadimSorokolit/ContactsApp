//
//  EditContactViewController.swift
//  ContactsApp
//
//  Created by Vadim Sorokolit on 16.07.2024.
//

import Foundation
import UIKit
import SnapKit

protocol EditContactViewControllerDelegate : AnyObject {
    func didReturnEditContact(editedContact: ContactStruct)
}

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
        static let jobPositionTextFieldTitle: String = "Job position"
        static let emailTextFieldTitle: String = "Email"
        static let nameTextFieldPlaceholder: String = "Enter name"
        static let jobPositionTextFieldPlaceholder: String = "Enter position"
        static let emailTextFieldPlaceholder: String = "Enter email"
        static let errorMessageEmptyFullName: String = "Full name can't be empty"
        static let errorMessageEmptyJobPosition: String = "Job position can't be empty"
        static let errorMessageEmptyEmail: String = "Email can't be empty"
        static let errorMessageEmailDoesntMustContainSpaces: String = "Email doesn't must contain spaces"
        static let errorMessageInvalidEmailAddress: String = "Invalid email address. Valid adress for example: test@test.com"
        static let predicateFormat: String = "SELF MATCHES %@"
        static let emailRegularExpression: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        static let addPhotoButtonSize: CGSize = CGSize(width: 143.0, height: 143.0)
        static let addPhotoButtonHeight: CGFloat = 143.0
        static let addPhotoButtonTopPadding: CGFloat = 12.0
        static let backButtonInsets: UIEdgeInsets = UIEdgeInsets(top: 10.0, left: .zero, bottom: .zero, right: 34.0)
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
    
    weak var delegate: EditContactViewControllerDelegate?
    
    private let titleLabelText: String
    private let originalContact: ContactStruct
    private var editContact: ContactStruct
    
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
            let image = xImage.resize(to: increasedSize)
            
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
        let separator = UIView()
        separator.backgroundColor = Constants.separatorBackgroundColor
        return separator
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
        textFieldWithTitle.textField.delegate = self
        textFieldWithTitle.configure(
            title: Constants.nameTextFieldTitle,
            placeholder: Constants.nameTextFieldPlaceholder
        )
        return textFieldWithTitle
    }()
    
    private lazy var textFieldWithTitleJobPosition: TextFieldWithTitle = {
        let textFieldWithTitle = TextFieldWithTitle()
        textFieldWithTitle.textField.delegate = self
        textFieldWithTitle.configure(
            title: Constants.jobPositionTextFieldTitle,
            placeholder: Constants.jobPositionTextFieldPlaceholder
        )
        return textFieldWithTitle
    }()
    
    private lazy var textFieldWithTitleEmail: TextFieldWithTitle = {
        let textFieldWithTitle = TextFieldWithTitle()
        textFieldWithTitle.textField.delegate = self
        textFieldWithTitle.configure(
            title: Constants.emailTextFieldTitle,
            placeholder: Constants.emailTextFieldPlaceholder
        )
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
        let tapGestureAddPhoto = UITapGestureRecognizer(target: self, action: #selector(self.onAddPhotoTapped))
        
        if let addPhotoImage = UIImage(named: Constants.addPhotoIconName) {
            let image = addPhotoImage.resize(to: Constants.addPhotoButtonSize)
            imageView.image = image
        }
        
        imageView.layer.cornerRadius = Constants.addPhotoButtonHeight / 2.0
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureAddPhoto)
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
    
    required init(title: String, contact: ContactStruct) {
        self.titleLabelText = title
        self.originalContact = contact
        self.editContact = contact
        
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
        self.setupFields()
        self.registerForNotifications()
    }
    
    private func setupViews() {
        let tapGestureHideKeyboard = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboardOnTap))
        self.view.addGestureRecognizer(tapGestureHideKeyboard)
        
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
        
        self.backButton.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.view.snp.top).offset(self.statusBarHeight + Constants.backButtonInsets.top)
            make.trailing.equalTo(self.view.snp.trailing).inset(Constants.backButtonInsets.right)
            make.size.equalTo(Constants.backButtonSize)
        })
        
        self.titleLabel.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.view.snp.top).offset(Constants.titleLabelTopPadding)
            make.leading.trailing.equalTo(self.view).inset(Constants.defaultLabelsPadding)
            make.height.equalTo(Constants.titleLabelHeight)
        })
        
        self.separator.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Constants.separatorTopInset)
            make.leading.trailing.equalTo(self.titleLabel)
            make.height.equalTo(Constants.separatorHeight)
        })
        
        self.scrollView.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.separator.snp.bottom)
            make.leading.trailing.bottom.equalTo(self.view)
        })
        
        self.containerView.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.edges.equalTo(self.scrollView.snp.edges)
            make.width.equalTo(self.scrollView.snp.width)
        })
        
        self.stackView.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.containerView.snp.top).offset(Constants.stackViewTopPadding)
            make.leading.trailing.equalTo(self.containerView).inset(Constants.defaultLabelsPadding)
        })
        
        self.labelPhoto.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.stackView.snp.bottom).offset(Constants.photoLabelTopPadding)
            make.leading.trailing.equalTo(self.titleLabel)
            make.height.equalTo(Constants.photoLabelHeight)
        })
        
        self.addPhotoView.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
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
    
    private func setupFields() {
        self.textFieldWithTitleName.textField.text = self.editContact.fullName
        self.textFieldWithTitleJobPosition.textField.text = self.editContact.jobPosition
        self.textFieldWithTitleEmail.textField.text = self.editContact.email
        self.addPhotoView.image = UIImage(data: self.editContact.photo ?? Data()) ?? UIImage(named: Constants.addPhotoIconName)
        self.updateSaveButtonState()
    }
    
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func checkValidEmail(_ value: String) -> String? {
        if value.isEmpty {
            return Constants.errorMessageEmptyEmail
        }
        
        if value.contains(" ") {
            return Constants.errorMessageEmailDoesntMustContainSpaces
        }
        
        let regularExpression = Constants.emailRegularExpression
        let predicate = NSPredicate(format: Constants.predicateFormat, regularExpression)
        
        if !predicate.evaluate(with: value) {
            return Constants.errorMessageInvalidEmailAddress
        }
        
        return nil
    }
    
    private func validateFields() -> String? {
        let fullName = self.textFieldWithTitleName.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let jobPosition = self.textFieldWithTitleJobPosition.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let email = self.textFieldWithTitleEmail.textField.text ?? ""
        
        if fullName.isEmpty {
            return Constants.errorMessageEmptyFullName
        }
        
        if jobPosition.isEmpty {
            return Constants.errorMessageEmptyJobPosition
        }
        
        if let emailError = self.checkValidEmail(email) {
            return emailError
        }
        
        self.editContact.fullName = fullName
        self.editContact.jobPosition = jobPosition
        self.editContact.email = email
        
        return nil
    }
    
    private func presentPhotoLibrary() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    private func adjustScrollViewForKeyboard(height: CGFloat) {
        let contentInset = UIEdgeInsets(top: .zero, left: .zero, bottom: height, right: .zero)
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = contentInset
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    private func updateSaveButtonState() {
        let hasChanges = (self.originalContact != self.editContact)
        self.saveButton.isEnabled = hasChanges
        self.saveButton.backgroundColor = Constants.saveButtonBackgroundColor.withAlphaComponent(hasChanges ? 1.0 : 0.5)
    }
    
    private func getTextFieldWithTitle(for textField: UITextField) -> TextFieldWithTitle? {
        switch textField {
            case self.textFieldWithTitleName.textField:
                return self.textFieldWithTitleName
            case self.textFieldWithTitleJobPosition.textField:
                return self.textFieldWithTitleJobPosition
            case self.textFieldWithTitleEmail.textField:
                return self.textFieldWithTitleEmail
            default:
                return nil
        }
    }
    
    private func updateContactProperty(for textField: UITextField, with text: String) {
        switch textField {
            case self.textFieldWithTitleName.textField:
                self.editContact.fullName = text
            case self.textFieldWithTitleJobPosition.textField:
                self.editContact.jobPosition = text
            case self.textFieldWithTitleEmail.textField:
                self.editContact.email = text
            default:
                break
        }
    }

    // MARK: - Events
    
    @objc private func onBackButtonDidTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func onAddPhotoTapped() {
        self.presentPhotoLibrary()
    }
    
    @objc private func onSaveButtonDidTap() {
        if let errorMessage = self.validateFields() {
            self.showErrorAlert(message: errorMessage)
        } else if let delegate = self.delegate {
            delegate.didReturnEditContact(editedContact: self.editContact)
            self.onBackButtonDidTap()
        }
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            self.adjustScrollViewForKeyboard(height: keyboardHeight)
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        self.adjustScrollViewForKeyboard(height: .zero)
    }
    
    @objc private func hideKeyboardOnTap() {
        self.view.endEditing(true)
    }
    
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension EditContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            self.addPhotoView.contentMode = .scaleAspectFill
            self.addPhotoView.image = selectedImage
            
            self.editContact.photo = selectedImage.pngData()
            
            self.updateSaveButtonState()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UITextFieldDelegate

extension EditContactViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.attributedPlaceholder = nil
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        self.updateContactProperty(for: textField, with: text)
        self.updateSaveButtonState()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !textField.hasText {
            if let textFieldWithTitle = self.getTextFieldWithTitle(for: textField) {
                textFieldWithTitle.setupDefaultPlaceholder()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
