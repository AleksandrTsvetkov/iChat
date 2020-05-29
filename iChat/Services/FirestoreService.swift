//
//  FirestoreService.swift
//  iChat
//
//  Created by Александр Цветков on 28.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

class FirestoreService {
    
    static let shared = FirestoreService()
    private let db = Firestore.firestore()
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
    func saveProfileWith(id: String, email: String, username: String, avatarImage: UIImage?, description: String, sex: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        guard Validators.isFilled(username: username, description: description, sex: sex) else {
            completion(.failure(UserError.notFilled))
            return
        }
        guard avatarImage != UIImage(named: "avatar") else {
            completion(.failure(UserError.photoNotExist))
            return
        }
        var userModel = UserModel(username: username, avatarStringURL: "not exist", id: id, email: email, description: description, sex: sex)
        StorageService.shared.upload(photo: avatarImage!) { (result) in
            switch result {
            case .success(let url):
                userModel.avatarStringURL = url.absoluteString
                self.usersRef.document(userModel.id).setData(userModel.dictionary) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(userModel))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getUserData(user: User, completion: @escaping (Result<UserModel, Error>) -> Void) {
        let docRef = usersRef.document(user.uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let userModel = UserModel(document: document) else {
                    completion(.failure(UserError.cannotCastToUserModel))
                    return
                }
                completion(.success(userModel))
            } else {
                completion(.failure(UserError.cannotGetUserInfo))
            }
        }
    }
    
    fileprivate init() {}
    
}
