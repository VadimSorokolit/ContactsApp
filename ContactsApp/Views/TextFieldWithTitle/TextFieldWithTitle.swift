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
        static let backgroundColor: UIColor = UIColor(hexString: "FFFFFF")
        static let titleLabelHeight: CGFloat = 19.0
        static let textFieldHeight: CGFloat = 38.0
        static let textFieldTopPadding: CGFloat = 10.0
    }
    
    // MARK: - Properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.titleLabelFont
        label.textColor = Constants.backgroundColor
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = Constants.textFieldFont
        textField.textColor = Constants.backgroundColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 2, height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
    }()
    
    var text: String? {
        get {
            return self.textField.text
        }
        set {
            self.textField.text = ""
        }
    }
    
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
        self.textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: Constants.backgroundColor]
        )
    }
    
}
