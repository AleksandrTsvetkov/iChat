//
//  AddPhotoView.swift
//  iChat
//
//  Created by Александр Цветков on 20.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

class AddPhotoView: UIView {
    
    let circleImageView: WebImageView = {
        let view = WebImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "avatar")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.tintColor = .buttonDark()
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(circleImageView)
        addSubview(plusButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            circleImageView.topAnchor.constraint(equalTo: self.topAnchor),
            circleImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            circleImageView.widthAnchor.constraint(equalToConstant: 100),
            circleImageView.heightAnchor.constraint(equalToConstant: 100),
            
            plusButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            plusButton.leadingAnchor.constraint(equalTo: circleImageView.trailingAnchor, constant: 16),
            plusButton.widthAnchor.constraint(equalToConstant: 30),
            plusButton.heightAnchor.constraint(equalToConstant: 30),
            
            self.bottomAnchor.constraint(equalTo: circleImageView.bottomAnchor),
            self.trailingAnchor.constraint(equalTo: plusButton.trailingAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleImageView.layer.masksToBounds = true
        circleImageView.layer.cornerRadius = circleImageView.frame.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
