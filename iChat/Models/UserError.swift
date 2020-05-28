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
    case cannotGetUserInfo
    case cannotCastToUserModel
}

extension UserError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Заполните все поля", comment: "")
        case .photoNotExist:
            return NSLocalizedString("Отсутствует фотография", comment: "")
        case .cannotGetUserInfo:
            return NSLocalizedString("Невозможно получить информацию о пользователе", comment: "")
        case .cannotCastToUserModel:
            return NSLocalizedString("Невозможно сконвертировать данные пользователя", comment: "")
        }
    }
}
