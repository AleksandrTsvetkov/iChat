//
//  UserError.swift
//  iChat
//
//  Created by Александр Цветков on 28.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

enum UserError {
    case notFilled
    case photoNotExist
}

extension UserError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Заполните все поля", comment: "")
        case .photoNotExist:
            return NSLocalizedString("Отсутствует фотография", comment: "")
        }
    }
}
