//
//  StorageService.swift
//  iChat
//
//  Created by Александр Цветков on 29.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit
import FirebaseStorage

class StorageService {
    
    static let shared = StorageService()
    let storageRef = Storage.storage().reference()
    private var avatarsRef: StorageReference {
        return storageRef.child("avatars")
    }
    private var chatsRef: StorageReference {
        return storageRef.child("images")
    }
    private var currentUserId: String {
        return Auth.auth().currentUser!.uid
    }
    
    func upload(photo: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard
            let scaledImage = photo.scaledToSafeUploadSize,
            let imageData = scaledImage.jpegData(compressionQuality: 0.4)
            else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        avatarsRef.child(currentUserId).putData(imageData, metadata: metaData) { (storageMetaData, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let _ = storageMetaData else { return }
            self.avatarsRef.child(self.currentUserId).downloadURL { (url, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let url = url else { return }
                completion(.success(url))
            }
        }
    }
    
    func uploadImage(image: UIImage, chat: ChatModel, completion: @escaping (Result<URL, Error>) -> Void) {
        guard
        let scaledImage = image.scaledToSafeUploadSize,
        let imageData = scaledImage.jpegData(compressionQuality: 0.4)
        else { return }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        let chatName = [chat.friendUsername, Auth.auth().currentUser!.uid].joined()
        chatsRef.child(chatName).child(imageName).putData(imageData, metadata: metadata) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard metadata != nil else { return }
            self.chatsRef.child(chatName).child(imageName).downloadURL { (url, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let url = url else { return }
                completion(.success(url))
            }
        }
    }
    
    func downloadImage(url: URL, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        let ref = Storage.storage().reference(forURL: url.absoluteString)
        let megaByte = Int64(1 * 1024 * 1024)
        ref.getData(maxSize: megaByte) { (data, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            completion(.success(UIImage(data: data)))
        }
    }
    
    fileprivate init() {}
}
