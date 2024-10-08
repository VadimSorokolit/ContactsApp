//
//  ContactCell.swift
//  ContactsApp
//
//  Created by Vadim Sorokolit on 10.07.2024.
//

import Foundation
import UIKit
import SnapKit

class ContactCell: UITableViewCell {
    
    // MARK: - Objects
    
    private struct Constants {
        static let fullNameLabelFont: UIFont? = UIFont(name: "Manrope-Bold", size: 16.0)
        static let jobPositionLabelFont: UIFont? = UIFont(name: "Manrope-Medium", size: 14.0)
        static let placeholderImageName: String = "placeholder"
        static let fullNameLabelInsets: UIEdgeInsets = UIEdgeInsets(top: 15.0, left: 14.0, bottom: .zero, right: 30.0)
        static let imageViewWidth: CGFloat = 50.0
        static let jobPositionLabelInsets: UIEdgeInsets = UIEdgeInsets(top: 3.0, left: .zero, bottom: 15.0, right: .zero)
        static let photoImageViewInsets: UIEdgeInsets = UIEdgeInsets(top: 15.0, left: 30.0, bottom: 15.0, right: .zero)
    }
    
    // MARK: - Properties
    
    static var reuseID: String {
        return String(describing: self)
    }
    
    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.fullNameLabelFont
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var jobPositionLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.jobPositionLabelFont
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Constants.imageViewWidth / 2.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError(GlobalConstants.fatalError)
    }
    
    // MARK: - Methods
    
    private func setup() {
        self.setupViews()
    }
    
    private func setupViews() {
        self.contentView.addSubview(self.photoImageView)
        self.contentView.addSubview(self.fullNameLabel)
        self.contentView.addSubview(self.jobPositionLabel)
        
        self.photoImageView.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.leading.equalTo(self.contentView.snp.leading).inset(Constants.photoImageViewInsets.left)
            make.size.equalTo(Constants.imageViewWidth)
        })
        
        self.fullNameLabel.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.contentView.snp.top).offset(Constants.fullNameLabelInsets.top)
            make.leading.equalTo(self.photoImageView.snp.trailing).offset(Constants.fullNameLabelInsets.left)
            make.trailing.equalTo(self.contentView.snp.trailing).inset(Constants.fullNameLabelInsets.right)
        })
        
        self.jobPositionLabel.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.fullNameLabel.snp.bottom).offset(Constants.jobPositionLabelInsets.top)
            make.leading.trailing.equalTo(self.fullNameLabel)
            make.bottom.equalTo(self.contentView.snp.bottom).inset(Constants.jobPositionLabelInsets.bottom)
        })
    }
    
    func setupCell(with contact: ContactStruct) {
        let contactFullName = contact.fullName
        let contactJobPosition = contact.jobPosition
        let contactPhoto = contact.photo
        
        self.fullNameLabel.text = contactFullName
        self.jobPositionLabel.text = contactJobPosition
        
        if let photoImage = contactPhoto {
            self.photoImageView.image = UIImage(data: photoImage)
        } else {
            self.photoImageView.image = UIImage(named: Constants.placeholderImageName)
        }
    }
    
    func hideSeparator() {
        self.separatorInset.left = UIScreen.main.bounds.width
    }
    
}

