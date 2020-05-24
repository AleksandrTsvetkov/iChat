//
//  SectionHeader.swift
//  iChat
//
//  Created by Александр Цветков on 24.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    
    //MARK: PROPERTIES
    static let reuseId = "SectionHeader"
    let title = UILabel()
    
    //VIEW LIFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        title.translatesAutoresizingMaskIntoConstraints = false
        addSubview(title)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.topAnchor),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            title.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: SETUP
    func confgure(text: String, font: UIFont?, textColor: UIColor) {
        title.text = text
        title.font = font
        title.textColor = textColor
    }
}
