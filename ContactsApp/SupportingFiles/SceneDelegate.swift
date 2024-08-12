//
//  SceneDelegate.swift
//  ContactsApp
//
//  Created by Vadim Sorokolit on 05.06.2024.
//

import Foundation
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Properties
    
    var window: UIWindow?
    let service: IAPIContacts
    
    // MARK: - Initializer
    
    init(service: IAPIContacts) {
        self.service = service
    }
    
    // MARK: - Methods
 
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let contactsViewModel = ContactsViewModel(service: self.service)
        let bootViewController = ContactsViewController(contactsViewModel: contactsViewModel)
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = bootViewController
        window.makeKeyAndVisible()
        self.window = window
    }
    
}
