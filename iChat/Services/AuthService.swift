//
//  AuthService.swift
//  iChat
//
//  Created by Александр Цветков on 27.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

class AuthService {
    
    static let shared = AuthService()
    private let auth = Auth.auth()
    
    func login(email: String?, password: String?, completion: @escaping (Result<User, Error>) -> Void) {
        guard Validators.notEmpty(email: email, password: password) else {
            completion(.failure(AuthError.notFilledFields))
            return
        }
        auth.signIn(withEmail: email!, password: password!) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
    
    func register(email: String?, password: String?, confirmPassword: String?, completion: @escaping (Result<User, Error>) -> Void) {
        Validators.validate(email: email, password: password, confirmPassword: confirmPassword) { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
        }
        auth.createUser(withEmail: email!, password: password!) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
    
    fileprivate init() {}
    
}
