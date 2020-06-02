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
    
    func waitingChatsObserve(chats: Array<ChatModel>,
                             completion: @escaping (Result<[ChatModel], Error>) -> Void) -> ListenerRegistration? {
        let chatsRef = db.collection(["users", currentUserId, "waitingChats"].joined(separator: "/"))
        return chatsObserve(chats: chats, chatsRef: chatsRef, completion: completion)
    }
    
    func activeChatsObserve(chats: Array<ChatModel>,
                            completion: @escaping (Result<[ChatModel], Error>) -> Void) -> ListenerRegistration? {
        let chatsRef = db.collection(["users", currentUserId, "activeChats"].joined(separator: "/"))
        return chatsObserve(chats: chats, chatsRef: chatsRef, completion: completion)
    }
    
    func messagesObserve(chat: ChatModel, completion: @escaping (Result<MessageModel, Error>) -> Void) -> ListenerRegistration? {
        let ref = usersRef.document(currentUserId).collection("activeChats").document(chat.friendId).collection("messages")
        let messageListener = ref.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            }
            guard let snapshot = querySnapshot else { return }
            snapshot.documentChanges.forEach { diff in
                guard let message = MessageModel(document: diff.document) else { return }
                switch diff.type {
                case .added:
                    completion(.success(message))
                case .modified:
                    break
                case .removed:
                    break
                }
            }
        }
        return messageListener
    }
    
    private func chatsObserve(chats: Array<ChatModel>, chatsRef: CollectionReference,
                              completion: @escaping (Result<[ChatModel], Error>) -> Void) -> ListenerRegistration? {
        var chats = chats
        let chatsListener = chatsRef.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let snapshot = querySnapshot else { return }
            snapshot.documentChanges.forEach { (diff) in
                guard let chat = ChatModel(document: diff.document) else { return }
                switch diff.type {
                case .added:
                    guard
                        !chats.contains(chat)
                        else { return }
                    chats.append(chat)
                case .modified:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats[index] = chat
                case .removed:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats.remove(at: index)
                }
            }
            completion(.success(chats))
        }
        return chatsListener
    }
    
    fileprivate init() {}
}
