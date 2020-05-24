//
//  WaitingChatCell.swift
//  iChat
//
//  Created by Александр Цветков on 22.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit
import SwiftUI

class WaitingChatCell: UICollectionViewCell, SelfConfiguringCell {
    
    //MARK: PROPERTIES
    static var reuseId: String = "WaitingChatCell"
    private let friendImageView = UIImageView()
    
    //MARK: VIEW LIFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: SETUP CELL
    func configure(with value: ChatPreview) {
        
    }
    
    private func setupConstraints() {
        
    }
}

//MARK: CANVAS PREVIEW
struct WaitingChatCellProvider: PreviewProvider {
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
