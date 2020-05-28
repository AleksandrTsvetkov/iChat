//
//  FirestoreService.swift
//  iChat
//
//  Created by Александр Цветков on 28.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

class FirestoreService {
    
    static let shared = FirestoreService()
    private let db = Firestore.firestore()
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
    func saveProfileWith(id: String, email: String, username: String, avatarImageString: String, description: String, sex: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        guard Validators.isFilled(username: username, description: description, sex: sex) else {
            completion(.failure(UserError.notFilled))
            return
        }
        let userModel = UserModel(username: username, avatarStringURL: avatarImageString, id: id, email: email, description: description, sex: sex)
        self.usersRef.document(userModel.id).setData(userModel.dictionary) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(userModel))
            }
        }
    }
    
    fileprivate init() {}
    
}
