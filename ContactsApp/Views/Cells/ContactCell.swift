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
        static let imageViewWidth: CGFloat = 50.0
        static let photoImageViewInsets: UIEdgeInsets = UIEdgeInsets(top: 15.0, left: 30.0, bottom: 15.0, right: 0.0)
        static let fullNameLabelInsets: UIEdgeInsets = UIEdgeInsets(top: 15.0, left: 14.0, bottom: 0.0, right: 30.0)
        static let jobPositionLabelInsets: UIEdgeInsets = UIEdgeInsets(top: 3.0, left: 0.0, bottom: 15.0, right: 0.0)
    }
    
    // MARK: - Properties
    
    static var reuseID: String {
        return String(describing: self)
    }
    
    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.fullNameLabelFont
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var jobPositionLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.jobPositionLabelFont
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Constants.imageViewWidth / 2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
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
        
        self.separatorInset = UIEdgeInsets(top: 0.0, left: 30.0, bottom: 0.0, right: 30.0)
        
        self.photoImageView.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.centerY.equalTo(self.contentView)
            make.leading.equalTo(self.contentView).inset(Constants.photoImageViewInsets.left)
            make.size.equalTo(Constants.imageViewWidth)
        })
        
        self.fullNameLabel.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.contentView.snp.top).offset(Constants.fullNameLabelInsets.top)
            make.leading.equalTo(self.photoImageView.snp.trailing).inset(-Constants.fullNameLabelInsets.left)
            make.trailing.equalTo(self.contentView.snp.trailing).inset(Constants.fullNameLabelInsets.right)
        })
        
        self.jobPositionLabel.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.fullNameLabel.snp.bottom).offset(Constants.jobPositionLabelInsets.top)
            make.leading.trailing.equalTo(self.fullNameLabel)
            make.bottom.equalTo(self.contentView.snp.bottom).inset(Constants.jobPositionLabelInsets.bottom)
        })
    }
    
    func setupCell(with contact: Contact) {
        let contactFullName = contact.fullName
        let contactJobPosition = contact.jobPosition
        let contactPhoto = contact.photo
        
        self.fullNameLabel.text = contactFullName
        self.jobPositionLabel.text = contactJobPosition
        
        if let photoImage = contactPhoto {
            self.photoImageView.image = photoImage
        } else {
            self.photoImageView.image = UIImage(named: Constants.placeholderImageName)
        }
    }
    
    func hideSeparator() {
        self.separatorInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: UIScreen.main.bounds.width)
    }
    
}

