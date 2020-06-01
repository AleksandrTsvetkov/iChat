//
//  ActiveChatCell.swift
//  iChat
//
//  Created by Александр Цветков on 22.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit
import SwiftUI

class ActiveChatCell: UICollectionViewCell, SelfConfiguringCell {
    
    //MARK: PROPERTIES
    static var reuseId: String = "ActiveChatCell"
    private let friendImageView = WebImageView()
    private let friendNameLabel = UILabel(text: "User name", font: .laoSangamMN20())
    private let lastMessageLabel = UILabel(text: "How are you?", font: .laoSangamMN18())
    private let gradientView = GradientView(from: .topTrailing, to: .bottomLeading, startColor: UIColor(hex: "C9A1F0"), endColor: UIColor(hex: "7AB2EB"))
    
    //MARK: INITIALIZERS
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: SETUP CELL
    private func setupConstraints() {
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        friendNameLabel.translatesAutoresizingMaskIntoConstraints = false
        lastMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(friendImageView)
        NSLayoutConstraint.activate([
            friendImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            friendImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            friendImageView.heightAnchor.constraint(equalToConstant: 66),
            friendImageView.widthAnchor.constraint(equalToConstant: 66)
        ])
        
        addSubview(gradientView)
        NSLayoutConstraint.activate([
            gradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            gradientView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 66),
            gradientView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        addSubview(friendNameLabel)
        NSLayoutConstraint.activate([
            friendNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            friendNameLabel.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 10),
            friendNameLabel.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: -16)
        ])
        
        addSubview(lastMessageLabel)
        NSLayoutConstraint.activate([
            lastMessageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6),
            lastMessageLabel.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 10),
            lastMessageLabel.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: -16)
        ])
    }
    
    func configure(with value: ChatPreview) {
        friendImageView.set(imageURL: value.friendAvatarImageString)
        friendNameLabel.text = value.friendUsername
        lastMessageLabel.text = value.lastMessage
    }
}

//MARK: CANVAS PREVIEW
struct ActiveChatCellProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let mainTabBarController = MainTabBarController()
        
        func makeUIViewController(context: Context) -> UIViewController {
            return mainTabBarController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            
        }
    }
}
