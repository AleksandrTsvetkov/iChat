//
//  UserCell.swift
//  iChat
//
//  Created by Александр Цветков on 22.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

class UserCell: UICollectionViewCell, SelfConfiguringCell {
    
    //MARK: PROPERTIES
    let userImageView = WebImageView()
    let userName = UILabel(text: "Alexey", font: .laoSangamMN20())
    let containerView = UIView()
    static var reuseId: String = "UserCell"
    
    //MARK: VIEW LIFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setupConstraints()
        
        self.layer.cornerRadius = 4
        
        self.layer.shadowColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.layer.cornerRadius = 4
        self.containerView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        userImageView.image = nil
    }
     
    //MARK: SETUP
    func configure<U>(with value: U) where U : Hashable {
        guard let user: UserModel = value as? UserModel else { return }
        userName.text = user.username
        userImageView.set(imageURL: user.avatarStringURL)
    }
    
    private func setupConstraints() {
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.backgroundColor = .red
        
        addSubview(containerView)
        containerView.addSubview(userImageView)
        containerView.addSubview(userName)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            userImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            userImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            userImageView.heightAnchor.constraint(equalTo: containerView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            userName.topAnchor.constraint(equalTo: userImageView.bottomAnchor),
            userName.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            userName.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            userName.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
}

// MARK: CANVAS PREVIEW
import SwiftUI

struct UserChatProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let tabBarVC = MainTabBarController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<UserChatProvider.ContainerView>) -> MainTabBarController {
            return tabBarVC
        }
        
        func updateUIViewController(_ uiViewController: UserChatProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<UserChatProvider.ContainerView>) {
            
        }
    }
}
