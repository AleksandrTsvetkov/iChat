//
//  GradientView.swift
//  iChat
//
//  Created by Александр Цветков on 22.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    //MARK: POINT
    enum Point {
        case topLeading
        case leading
        case bottomLeading
        case top
        case center
        case bottom
        case topTrailing
        case trailing
        case bottomTrailing

        var point: CGPoint {
            switch self {
            case .topLeading:
                return CGPoint(x: 0, y: 0)
            case .leading:
                return CGPoint(x: 0, y: 0.5)
            case .bottomLeading:
                return CGPoint(x: 0, y: 1.0)
            case .top:
                return CGPoint(x: 0.5, y: 0)
            case .center:
                return CGPoint(x: 0.5, y: 0.5)
            case .bottom:
                return CGPoint(x: 0.5, y: 1.0)
            case .topTrailing:
                return CGPoint(x: 1.0, y: 0.0)
            case .trailing:
                return CGPoint(x: 1.0, y: 0.5)
            case .bottomTrailing:
                return CGPoint(x: 1.0, y: 1.0)
            }
        }
    }

    //MARK: VIEW LIFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(from startPoint: Point, to endPoint: Point, startColor: UIColor?, endColor: UIColor?) {
        self.init()
        setupGradient(from: startPoint, to: endPoint, startColor: startColor, endColor: endColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    //MARK: SETUP
    private func setupGradient(from startPoint: Point, to endPoint: Point, startColor: UIColor?, endColor: UIColor?) {
        self.layer.addSublayer(gradientLayer)
        setupGradientColors(startColor: startColor, endColor: endColor)
        gradientLayer.startPoint = startPoint.point
        gradientLayer.endPoint = endPoint.point
    }
    
    private func setupGradientColors(startColor: UIColor?, endColor: UIColor?) {
        guard let startColor = startColor, let endColor = endColor else { return }
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
}
