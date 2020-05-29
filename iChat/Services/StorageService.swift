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
    
    fileprivate init() {}
}
