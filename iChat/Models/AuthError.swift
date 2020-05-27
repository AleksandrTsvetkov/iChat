//
//  AuthError.swift
//  iChat
//
//  Created by Александр Цветков on 27.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

enum AuthError {
    case notFilledFields
    case invalidEmail
    case passwordsNotMatch
    case serverError
    case unknownError
    case shortPassword
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilledFields:
            return NSLocalizedString("Пожалуйста, заполните все поля", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Пожалуйста, введите действительный адрес электронной почты", comment: "")
        case .passwordsNotMatch:
            return NSLocalizedString("Пароли должны совпадать", comment: "")
        case .serverError:
            return NSLocalizedString("Ошибка сервера", comment: "")
        case .unknownError:
            return NSLocalizedString("Неизвестная ошибка", comment: "")
        case .shortPassword:
            return NSLocalizedString("Пароль должен содержать как минимум 6 символов", comment: "")
        }
    }
}
