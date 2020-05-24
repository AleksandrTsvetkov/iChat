//
//  SelfConfiguringCell.swift
//  iChat
//
//  Created by Александр Цветков on 22.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

protocol SelfConfiguringCell {
    static var reuseId: String { get }
    func configure(with value: ChatPreview)
}
