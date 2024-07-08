//
//  ResizeImage.swift
//  ContactsApp
//
//  Created by Vadim Sorokolit on 08.07.2024.
//

import Foundation
import UIKit

extension UIImage {
    
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        self.draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}
