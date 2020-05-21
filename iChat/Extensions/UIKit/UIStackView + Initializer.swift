//
//  UIStackView + Initializer.swift
//  iChat
//
//  Created by Александр Цветков on 20.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

extension UIStackView {
    convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        
    }
}
