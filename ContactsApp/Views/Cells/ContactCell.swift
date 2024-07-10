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
        static let reuseIDName: String = "ContactCell"
        static let fullNameFont: UIFont = UIFont(name: "Manrope-Bold", size: 16.0) ?? UIFont.systemFont(ofSize: 16.0)
        static let jobPositionFont: UIFont = UIFont(name: "Manrope-Medium", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
        static let imageViewWidth: CGFloat = 50.0
        static let fullNameLabelHeight: CGFloat = 22.0
        static let jobPositionHeight: CGFloat = 19.0
        static let photoImageViewInsets: UIEdgeInsets = UIEdgeInsets(top: 15.0, left: 30.0, bottom: 17.0, right: 0.0)
        static let fullNameLabelInsets: UIEdgeInsets = UIEdgeInsets(top: 18.0, left: 14.0, bottom: 0.0, right: 37.0)
        static let jobPositionInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    // MARK: - Properties
    
    static let reuseID = Constants.reuseIDName
    
    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.fullNameFont
        return label
    }()
    
    private lazy var jobPositionLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.jobPositionFont
        return label
    }()
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Constants.imageViewWidth / 2
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
        self.contentView.addSubview(self.fullNameLabel)
        self.contentView.addSubview(self.jobPositionLabel)
        self.contentView.addSubview(self.photoImageView)
        
        self.photoImageView.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.contentView.snp.top).offset(Constants.photoImageViewInsets.top)
            make.leading.equalTo(self.contentView.snp.leading).offset(Constants.photoImageViewInsets.left)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-Constants.photoImageViewInsets.bottom)
            make.width.height.equalTo(Constants.imageViewWidth)
        })
        
        self.fullNameLabel.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.contentView.snp.top).offset(Constants.fullNameLabelInsets.top)
            make.leading.equalTo(self.photoImageView.snp.trailing).offset(Constants.fullNameLabelInsets.left)
            make.trailing.equalTo(self.contentView.snp.trailing).offset(Constants.fullNameLabelInsets.right)
            make.height.equalTo(Constants.fullNameLabelHeight)
        })
        
        self.jobPositionLabel.snp.makeConstraints({ (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.fullNameLabel.snp.bottom).offset(Constants.jobPositionInsets.top)
            make.leading.equalTo(self.photoImageView.snp.trailing).offset(Constants.jobPositionInsets.left)
            make.trailing.equalTo(self.contentView.snp.trailing).offset(Constants.jobPositionInsets.right)
            make.height.equalTo(Constants.jobPositionHeight)
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
            self.photoImageView.image = UIImage(systemName: "photo")
        }
    }
    
}

