//
//  UIView + Gradient.swift
//  iChat
//
//  Created by Александр Цветков on 25.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

extension UIView {
    
    func applyGradients(cornerRadius: CGFloat) {
        self.backgroundColor = nil
        self.layoutIfNeeded()
        let gradientView = GradientView(from: .topTrailing, to: .bottomLeading, startColor: UIColor(hex: "C9A1F0"), endColor: UIColor(hex: "7AB2EB"))
        guard let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer else { return }
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = cornerRadius
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
