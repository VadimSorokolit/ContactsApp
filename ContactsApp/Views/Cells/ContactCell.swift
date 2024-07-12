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
        static let fullNameFont: UIFont? = UIFont(name: "Manrope-Bold", size: 16.0)
        static let jobPositionFont: UIFont? = UIFont(name: "Manrope-Medium", size: 14.0)
        static let placeholderImageName: String = "placeholder"
        static let imageViewWidth: CGFloat = 50.0
        static let photoImageViewInsets: UIEdgeInsets = UIEdgeInsets(top: 15.0, left: 30.0, bottom: 15.0, right: 0.0)
        static let fullNameLabelInsets: UIEdgeInsets = UIEdgeInsets(top: 15.0, left: 14.0, bottom: 0.0, right: 30.0)
        static let jobPositionInsets: UIEdgeInsets = UIEdgeInsets(top: 3.0, left: 14.0, bottom: 15.0, right: 30.0)
    }
    
    // MARK: - Properties
    
    static var reuseID: String {
        return String(describing: self)
    }
    
    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.fullNameFont
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var jobPositionLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.jobPositionFont
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
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
        
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets(top: 0, left: 30.0, bottom: 0, right: 30.0)
        self.layoutMargins = UIEdgeInsets(top: 0, left: 30.0, bottom: 0, right: 30.0)
        
        self.photoImageView.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.contentView.snp.top).offset(Constants.photoImageViewInsets.top)
            make.leading.equalTo(self.contentView.snp.leading).offset(Constants.photoImageViewInsets.left)
            make.bottom.lessThanOrEqualTo(self.contentView.snp.bottom).offset(-Constants.photoImageViewInsets.bottom)
            make.width.height.equalTo(Constants.imageViewWidth)
        })
        
        self.fullNameLabel.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.contentView.snp.top).offset(Constants.fullNameLabelInsets.top)
            make.leading.equalTo(self.photoImageView.snp.trailing).offset(Constants.fullNameLabelInsets.left)
            make.trailing.equalTo(self.contentView.snp.trailing).offset(-Constants.fullNameLabelInsets.right)
        })
        
        self.jobPositionLabel.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.fullNameLabel.snp.bottom).offset(Constants.jobPositionInsets.top)
            make.leading.equalTo(self.photoImageView.snp.trailing).offset(Constants.jobPositionInsets.left)
            make.trailing.equalTo(self.contentView.snp.trailing).offset(-Constants.jobPositionInsets.right)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-Constants.jobPositionInsets.bottom)
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
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
    }
    
}

