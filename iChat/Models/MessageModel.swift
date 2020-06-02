//
//  MessageModel.swift
//  iChat
//
//  Created by Александр Цветков on 29.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit
import MessageKit

struct ImageItem: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}

struct MessageModel: Hashable, MessageType {
    let content: String
    let sendingDate: Date
    let id: String?
    
    var kind: MessageKind {
        if let image = image {
            let mediaItem = ImageItem(url: nil, image: nil, placeholderImage: image, size: image.size)
            return .photo(mediaItem)
        } else {
            return .text(content)
        }
    }
    var sender: SenderType
    var messageId: String {
        return id ?? UUID().uuidString
    }
    var sentDate: Date {
        return sendingDate
    }
    var image: UIImage?
    var downloadUrl: URL?
    
    var dictionary: [String: Any] {
        var dict: [String: Any] = [
            "created": sendingDate,
            "senderId": sender.senderId,
            "senderName": sender.displayName
        ]
        if let url = downloadUrl {
            dict["url"] = url.absoluteString
        } else {
            dict["content"] = content
        }
        return dict
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard
            let sendingDate = data["created"] as? Timestamp,
            let senderId = data["senderId"] as? String,
            let senderUsername = data["senderName"] as? String
            else { return nil }
        
        self.id = document.documentID
        self.sendingDate = sendingDate.dateValue()
        self.sender = SenderModel(senderId: senderId, displayName: senderUsername)
        if let content = data["content"] as? String {
            self.content = content
            downloadUrl = nil
        } else if let urlString = data["url"] as? String, let url = URL(string: urlString) {
            downloadUrl = url
            self.content = ""
        } else {
            return nil
        }
    }
    
    init(user: UserModel, content: String) {
        self.content = content
        sender = SenderModel(senderId: user.id, displayName: user.username)
        self.sendingDate = Date()
        self.id = nil
    }
    
    init(user: UserModel, image: UIImage) {
        sender = SenderModel(senderId: user.id, displayName: user.username)
        self.image = image
        content = ""
        sendingDate = Date()
        id = nil
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
    }
    
    static func == (lhs: MessageModel, rhs: MessageModel) -> Bool {
        return lhs.messageId == rhs.messageId
       }
}
