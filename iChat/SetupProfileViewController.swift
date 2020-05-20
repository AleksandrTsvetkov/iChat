//
//  SetupProfileViewController.swift
//  iChat
//
//  Created by Александр Цветков on 20.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit
import SwiftUI

class SetupProfileViewController: UIViewController {
    
    //MARK: USER INTERFACE
    private let addPhotoView = AddPhotoView()
    
    //MARK: VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUserInterface()
    }
    
    //MARK: SETUP
    private func setupUserInterface() {
        addPhotoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addPhotoView)
        NSLayoutConstraint.activate([
            addPhotoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            addPhotoView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

//MARK: CANVAS PREVIEW
struct SetupProfileVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let setupProfileViewController = SetupProfileViewController()
        
        func makeUIViewController(context: Context) -> UIViewController {
            return setupProfileViewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            
        }
    }
}
