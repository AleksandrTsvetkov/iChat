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
    private let welcomeLabel = UILabel(text: "Set up profile", font: .avenir26())
    private let fullNameLabel = UILabel(text: "Full name")
    private let fullNameTextField = OneLineTextField(font: .avenir20())
    private let aboutMeLabel = UILabel(text: "About me")
    private let aboutMeTextField = OneLineTextField(font: .avenir20())
    private let sexLabel = UILabel(text: "Sex")
    private let needAnAccountLabel = UILabel(text: "Need an account?")
    private let sexSegmentedControl = UISegmentedControl(first: "Male", second: "Female")
    private let goToChatsButton = UIButton(title: "Go to chats!", titleColor: .white, backgroundColor: .buttonDark())
    
    //MARK: VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUserInterface()
    }
    
    //MARK: SETUP
    private func setupUserInterface() {
        let fullNameStackView = UIStackView(arrangedSubviews: [fullNameLabel, fullNameTextField], axis: .vertical, spacing: 0)
        let aboutMeStackView = UIStackView(arrangedSubviews: [aboutMeLabel, aboutMeTextField], axis: .vertical, spacing: 0)
        let sexStackView = UIStackView(arrangedSubviews: [sexLabel, sexSegmentedControl], axis: .vertical, spacing: 0)
        goToChatsButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let stackView = UIStackView(arrangedSubviews: [fullNameStackView, aboutMeStackView, sexStackView, goToChatsButton],
                                    axis: .vertical, spacing: 24)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        addPhotoView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
        view.addSubview(addPhotoView)
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            addPhotoView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 30),
            addPhotoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: addPhotoView.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
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
