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
        
        viewControllers = [
            generateNavigationController(rootViewController: conversationsViewController, title: "Conversations", image: convImage),
            generateNavigationController(rootViewController: peopleViewController, title: "People", image: peopleImage)
        ]
    }
    
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        return navigationController
    }
}
