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
    
    // MARK: - Methods
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let contactsService = CoreDataService(persistentContainer: appDelegate.persistentContainer)
        let contactsViewModel = ContactsViewModel(service: contactsService)
        let contactsViewController = ContactsViewController(contactsViewModel: contactsViewModel)
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = contactsViewController
        window.makeKeyAndVisible()
        self.window = window
    }
    
}
