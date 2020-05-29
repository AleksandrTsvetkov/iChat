//
//  AuthViewController.swift
//  iChat
//
//  Created by Александр Цветков on 20.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit
import SwiftUI
import GoogleSignIn

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
        googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
        
        signUpVC.delegate = self
        loginVC.delegate = self
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    //MARK: USER EVENTS HANDLING
    @objc private func emailButtonTapped() {
        present(signUpVC, animated: true)
    }
    
    @objc private func loginButtonTapped() {
        present(loginVC, animated: true)
    }
    
    @objc private func googleButtonTapped() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
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

//MARK: GIDSignInDelegate
extension AuthViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
        AuthService.shared.googleLogin(user: user, error: error) { (result) in
            switch result {
            case .success(let user):
                FirestoreService.shared.getUserData(user: user) { (result) in
                    let window = UIApplication.shared.connectedScenes
                        .filter({ $0.activationState == .foregroundActive })
                        .map({ $0 as? UIWindowScene })
                        .compactMap({ $0 })
                        .first?.windows
                        .filter({ $0.isKeyWindow }).first
                    let vc = window?.rootViewController
                    switch result {
                    case .success(let userModel):
                        vc?.showAlert(title: "Успешно", message: "Вы авторизованы") {
                            let mainTabBarController = MainTabBarController(currentUser: userModel)
                            mainTabBarController.modalPresentationStyle = .fullScreen
                            vc?.present(mainTabBarController, animated: true)
                        }
                    case .failure(_):
                        vc?.showAlert(title: "Успешно", message: "Вы зарегистрированы") {
                            vc?.present(SetupProfileViewController(currentUser: user), animated: true)
                        }
                    }
                }
            case .failure(let error):
                self.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
        
    }
}

//MARK: AuthNavigationDelegate
extension AuthViewController: AuthNavigationDelegate {
    
    func toLoginVC() {
        present(loginVC, animated: true)
    }
    
    func toSignUpVC() {
        present(signUpVC, animated: true)
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
