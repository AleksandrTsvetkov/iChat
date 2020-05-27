//
//  Validators.swift
//  iChat
//
//  Created by Александр Цветков on 27.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

class Validators {
    
    static func validate(email: String?, password: String?, confirmPassword: String?, completion: @escaping (AuthError?) -> Void) {
        guard let email = email, let password = password, let confirmPassword = confirmPassword,
            isFilled(email: email, password: password, confirmPassword: confirmPassword) else {
                completion(.notFilledFields)
                return
        }
        guard isSimpleEmail(email) else {
            completion(.invalidEmail)
            return
        }
        guard password == confirmPassword else {
            completion(.passwordsNotMatch)
            return
        }
        guard password.count >= 6 && confirmPassword.count >= 6 else {
            completion(.shortPassword)
            return
        }
        completion(nil)
    }
    
    static func notEmpty(email: String?, password: String?) -> Bool {
        guard let email = email, let password = password, email != "", password != "" else { return false }
        return true
    }
    
    static private func isFilled(email: String?, password: String?, confirmPassword: String?) -> Bool {
        guard let email = email, let password = password, let confirmPassword = confirmPassword,
            email != "", password != "", confirmPassword != "" else { return false }
        return true
    }
    
    static private func isSimpleEmail(_ email: String) -> Bool {
        let emailRegEx = "^.+@.+\\..{2,}$"
        return check(text: email, regEx: emailRegEx)
    }
    
    private static func check(text: String, regEx: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: text)
    }
}
