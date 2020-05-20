//
//  LoginViewController.swift
//  iChat
//
//  Created by Александр Цветков on 20.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit
import SwiftUI

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}

//MARK: CANVAS PREVIEW
struct LoginUpVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let loginViewController = LoginViewController()
        
        func makeUIViewController(context: Context) -> UIViewController {
            return loginViewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            
        }
    }
}
