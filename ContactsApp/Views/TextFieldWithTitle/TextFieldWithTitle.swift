//
//  TextFieldWithTitle.swift
//  ContactsApp
//
//  Created by Vadim Sorokolit on 16.07.2024.
//

import Foundation
import UIKit
import SnapKit

class TextFieldWithTitle: UIView {
    
    // MARK: - Objects
    
    private struct Constants {
        static let titleLabelFont: UIFont? = UIFont(name: "Manrope-Bold", size: 14.0)
        static let textFieldFont: UIFont? = UIFont(name: "Manrope-Medium", size: 28.0)
        static let placeholderFont: UIFont = UIFont(name: "Manrope-Medium", size: 28.0) ?? .systemFont(ofSize: 28.0)
        static let backgroundColor: UIColor = UIColor(hexString: "FFFFFF")
        static let placeholderColor: UIColor = UIColor(hexString: "FFFFFF")
        static let textFieldTextColor: UIColor = UIColor(hexString: "FFFFFF")
        static let titleLabelHeight: CGFloat = 19.0
        static let textFieldHeight: CGFloat = 38.0
        static let textFieldTopPadding: CGFloat = 10.0
        static let textFieldFrameWidth: Double = 2.0
    }
    
    // MARK: - Properties
    
    weak var delegate: UITextFieldDelegate?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.titleLabelFont
        label.textColor = Constants.backgroundColor
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self.delegate
        textField.font = Constants.textFieldFont
        textField.textColor = Constants.textFieldTextColor
        let textFieldFrame = CGRect(x: .zero, y: .zero, width: Constants.textFieldFrameWidth, height: textField.frame.height)
        textField.leftView = UIView(frame: textFieldFrame)
        textField.leftViewMode = .always
        return textField
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupViews()
    }
    
    // MARK: - Methods
    
    private func setupViews() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.textField)
        
        self.titleLabel.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.leading.trailing.equalTo(self)
            make.height.equalTo(Constants.titleLabelHeight)
        })
        
        self.textField.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Constants.textFieldTopPadding)
            make.leading.trailing.bottom.equalTo(self)
            make.height.equalTo(Constants.textFieldHeight)
        })
    }
    
    func configure(title: String, placeholder: String) {
        self.titleLabel.text = title
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: Constants.placeholderColor,
            .font: Constants.placeholderFont
        ]
        
        let attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        self.textField.attributedPlaceholder = attributedPlaceholder
    }
    
}


