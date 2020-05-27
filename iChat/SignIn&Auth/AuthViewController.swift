//
//  AuthViewController.swift
//  iChat
//
//  Created by Александр Цветков on 20.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit
import SwiftUI

class AuthViewController: UIViewController {
    
    //MARK: VIEWS
    private let googleLabel = UILabel(text: "Get started with")
    private let emailLabel = UILabel(text: "Or sign up with")
    private let loginLabel = UILabel(text: "Already onboard?")
    private let signUpVC = SignUpViewController()
    private let loginVC = LoginViewController()
    
    private let googleButton: UIButton = {
        let button = UIButton(title: "Google", titleColor: .black, backgroundColor: .white, isShadow: true)
        button.customizeGoogleButton()
        return button
    }()
    private let emailButton = UIButton(title: "Email", titleColor: .white, backgroundColor: .buttonDark())
    private let loginButton = UIButton(title: "Login", titleColor: .buttonRed(), backgroundColor: .white, isShadow: true)
    
    private let logoImageView = UIImageView(image: UIImage(named: "Logo"), contentMode: .scaleAspectFit)
    
    //MARK: VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUserInterface()
        
        emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    //MARK: USER EVENTS HANDLING
    @objc private func emailButtonTapped() {
        present(signUpVC, animated: true)
    }
    
    @objc private func loginButtonTapped() {
        present(loginVC, animated: true)
    }
    
    //MARK: SETUP
    private func setupUserInterface() {
        let googleLabeledButton = LabeledButton(label: googleLabel, button: googleButton)
        let emailLabeledButton = LabeledButton(label: emailLabel, button: emailButton)
        let loginLabeledButton = LabeledButton(label: loginLabel, button: loginButton)
        let stackView = UIStackView(arrangedSubviews: [googleLabeledButton, emailLabeledButton, loginLabeledButton],
                                    axis: .vertical, spacing: 40)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        view.addSubview(stackView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 56),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
}

//MARK: CANVAS PREVIEW
struct AuthVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let authViewController = AuthViewController()
        
        func makeUIViewController(context: Context) -> UIViewController {
            return authViewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            
        }
    }
}
