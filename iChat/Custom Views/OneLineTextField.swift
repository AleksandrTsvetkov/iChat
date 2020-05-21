//
//  OneLineTextField.swift
//  iChat
//
//  Created by Александр Цветков on 20.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

class OneLineTextField: UITextField {
    convenience init(font: UIFont? = .avenir20()) {
        self.init()
        self.borderStyle = .none
        self.translatesAutoresizingMaskIntoConstraints = false
        let bottomView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bottomView.backgroundColor = .textFieldLight()
        addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
    }
}
