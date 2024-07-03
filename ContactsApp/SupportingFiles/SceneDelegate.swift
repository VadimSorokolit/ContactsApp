//
//  SceneDelegate.swift
//  ContactsApp
//
//  Created by Vadim Sorokolit on 05.06.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    private func setupNavigationController() -> UINavigationController {
        let bootViewController = ContactsViewController()
        let navController = UINavigationController(rootViewController: bootViewController)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.shadowImage = UIImage()
        appearance.backgroundColor = .white
        
        navController.navigationBar.standardAppearance = appearance
        navController.navigationBar.scrollEdgeAppearance = appearance
        
        return navController
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = self.setupNavigationController()
        window.makeKeyAndVisible()
        self.window = window
    }
    
}
