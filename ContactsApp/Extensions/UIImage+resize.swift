//
//  UIImage+resized.swift
//  ContactsApp
//
//  Created by Vadim Sorokolit on 08.07.2024.
//

import Foundation
import UIKit

extension UIImage {
    
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, .zero)
        defer { UIGraphicsEndImageContext() }
        self.draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}
