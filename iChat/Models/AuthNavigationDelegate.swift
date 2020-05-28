//
//  AuthNavigationDelegate.swift
//  iChat
//
//  Created by Александр Цветков on 28.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

protocol AuthNavigationDelegate: class {
    func toLoginVC()
    func toSignUpVC()
}
