//
//  LoginViewController.swift
//  iChat
//
//  Created by Александр Цветков on 20.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit
import SwiftUI
import GoogleSignIn

class LoginViewController: UIViewController {
    
    //MARK: USER INTERFACE
    private let welcomeLabel = UILabel(text: "Welcome back!", font: .avenir26())
    private let loginWithLabel = UILabel(text: "Login with")
    private let orLabel = UILabel(text: "or")
    private let emailLabel = UILabel(text: "Email")
    private let emailTextField = OneLineTextField(font: .avenir20())
    private let passwordTextField = OneLineTextField(font: .avenir20())
    private let passwordLabel = UILabel(text: "Password")
    private let needAnAccountLabel = UILabel(text: "Need an account?")
    private let googleButton: UIButton = {
        let button = UIButton(title: "Google", titleColor: .black, backgroundColor: .white, isShadow: true)
        button.customizeGoogleButton()
        return button
    }()
    private let loginButton = UIButton(title: "Login", titleColor: .white, backgroundColor: .buttonDark())
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.buttonRed(), for: .normal)
        button.titleLabel?.font = .avenir20()
        button.contentHorizontalAlignment = .leading
        return button
    }()
    weak var delegate: AuthNavigationDelegate?
    
    //MARK: VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUserInterface()
        
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
        
        emailTextField.addTarget(self, action: #selector(hideKeyboard), for: .primaryActionTriggered)
        passwordTextField.addTarget(self, action: #selector(hideKeyboard), for: .primaryActionTriggered)
    }
    
    //MARK: USER EVENTS HANDLING
    @objc private func signUpButtonTapped() {
        dismiss(animated: true) {
            self.delegate?.toSignUpVC()
        }
    }
    
    @objc private func loginButtonTapped() {
        AuthService.shared.login(email: emailTextField.text, password: passwordTextField.text) { (result) in
            switch result {
            case .success(let user):
                self.showAlert(title: "Успешно", message: String(describing: user.email)) {
                    FirestoreService.shared.getUserData(user: user) { (result) in
                        switch result {
                        case .success(let userModel):
                            let mainTabBarController = MainTabBarController(currentUser: userModel)
                            mainTabBarController.modalPresentationStyle = .fullScreen
                            self.present(mainTabBarController, animated: true)
                        case .failure(_):
                            let setupProfileVC = SetupProfileViewController(currentUser: user)
                            setupProfileVC.modalPresentationStyle = .fullScreen
                            self.present(setupProfileVC, animated: true)
                        }
                    }
                }
            case .failure(let error):
                self.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
    
    @objc private func googleButtonTapped() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: SETUP
    private func setupUserInterface() {
        let labeledLoginWithButton = LabeledButton(label: loginWithLabel, button: googleButton)
        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField], axis: .vertical, spacing: 0)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField], axis: .vertical, spacing: 0)
        let stackView = UIStackView(arrangedSubviews:
            [labeledLoginWithButton, orLabel, emailStackView, passwordStackView, loginButton],
                                    axis: .vertical, spacing: 22)
        let bottomStackView = UIStackView(arrangedSubviews: [needAnAccountLabel, signUpButton], axis: .horizontal, spacing: 10)
        bottomStackView.alignment = .firstBaseline
        loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
        view.addSubview(stackView)
        view.addSubview(bottomStackView)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
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
