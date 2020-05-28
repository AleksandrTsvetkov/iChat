//
//  MainTabBarController.swift
//  iChat
//
//  Created by Александр Цветков on 21.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor(hex: "8E5AF7")
        let boldConfiguration = UIImage.SymbolConfiguration(weight: .medium)
        let convImage = UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: boldConfiguration)
        let peopleImage = UIImage(systemName: "person.2", withConfiguration: boldConfiguration)
        let conversationsViewController = ConversationsViewController()
        let peopleViewController = PeopleViewController()
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(logOut))
        tabBar.addGestureRecognizer(gestureRecognizer)
        viewControllers = [
            generateNavigationController(rootViewController: peopleViewController, title: "People", image: peopleImage),
            generateNavigationController(rootViewController: conversationsViewController, title: "Conversations", image: convImage)
        ]
    }
    
    @objc private func logOut() {
        let ac = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .alert)
        let signOut = UIAlertAction(title: "Sign Out", style: .destructive) { _ in
            do {
                try Auth.auth().signOut()
                let window = UIApplication.shared.connectedScenes
                    .filter({ $0.activationState == .foregroundActive })
                    .map({ $0 as? UIWindowScene })
                    .compactMap({ $0 })
                    .first?.windows
                    .filter({ $0.isKeyWindow }).first
                window?.rootViewController = AuthViewController()
            } catch {
                print("\(error.localizedDescription) in \(#function)")
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        ac.addAction(signOut)
        ac.addAction(cancel)
        present(ac, animated: true)
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        return navigationController
    }
}
