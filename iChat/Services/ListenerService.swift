//
//  ListenerService.swift
//  iChat
//
//  Created by Александр Цветков on 29.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

class ListenerService {
    
    static let shared = ListenerService()
    private let db = Firestore.firestore()
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    private var currentUserId: String {
        return Auth.auth().currentUser!.uid
    }
    
    func usersObserve(users: Array<UserModel>,
                      completion: @escaping (Result<[UserModel], Error>) -> Void) -> ListenerRegistration? {
        var users = users
        let usersListener = usersRef.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let snapshot = querySnapshot else { return }
            snapshot.documentChanges.forEach { (diff) in
                guard let user = UserModel(document: diff.document) else { return }
                switch diff.type {
                case .added:
                    guard
                        !users.contains(user),
                        user.id != self.currentUserId
                        else { return }
                    users.append(user)
                case .modified:
                    guard let index = users.firstIndex(of: user) else { return }
                    users[index] = user
                case .removed:
                    guard let index = users.firstIndex(of: user) else { return }
                    users.remove(at: index)
                }
            }
            completion(.success(users))
        }
        return usersListener
    }
    
    fileprivate init() {}
}
