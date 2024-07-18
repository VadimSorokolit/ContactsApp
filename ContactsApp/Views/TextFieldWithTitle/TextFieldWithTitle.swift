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
        textField.borderStyle = .roundedRect
        textField.font = Constants.textFieldFont
        textField.textColor = Constants.backgroundColor
        return textField
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(textField)
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.titleLabelHeight)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.textFieldTopPadding)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.textFieldHeight)
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(title: String, placeholder: String) {
        titleLabel.text = title
        textField.placeholder = placeholder
    }
}
