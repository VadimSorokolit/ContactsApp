//
//  SceneDelegate.swift
//  ContactsApp
//
//  Created by Vadim Sorokolit on 05.06.2024.
//

import Foundation
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
 
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let apiContacts: IAPIContacts = CoreDataService()
        let contactsViewModel = ContactsViewModel(service: apiContacts)
        let bootViewController = ContactsViewController(contactsViewModel: contactsViewModel)
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = bootViewController
        window.makeKeyAndVisible()
        self.window = window
    }
    
}
