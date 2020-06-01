//
//  MessageModel.swift
//  iChat
//
//  Created by Александр Цветков on 29.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit
import MessageKit

struct MessageModel: Hashable, MessageType {
    let content: String
    let sendingDate: Date
    let id: String?
    
    var kind: MessageKind {
        return .text(content)
    }
    var sender: SenderType
    var messageId: String {
        return id ?? UUID().uuidString
    }
    var sentDate: Date {
        return sendingDate
    }
    
    var dictionary: [String: Any] {
        let dict: [String: Any] = [
            "created": sendingDate,
            "senderId": sender.senderId,
            "senderName": sender.displayName,
            "content": content
        ]
        return dict
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard
            let sendingDate = data["created"] as? Timestamp,
            let senderId = data["senderId"] as? String,
            let senderUsername = data["senderName"] as? String,
            let content = data["content"] as? String
            else { return nil }
        
        self.id = document.documentID
        self.sendingDate = sendingDate.dateValue()
        self.sender = SenderModel(senderId: senderId, displayName: senderUsername)
        self.content = content
    }
    
    init(user: UserModel, content: String) {
        self.content = content
        sender = SenderModel(senderId: user.id, displayName: user.username)
        self.sendingDate = Date()
        self.id = nil
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
    }
    
    static func == (lhs: MessageModel, rhs: MessageModel) -> Bool {
        return lhs.messageId == rhs.messageId
       }
}
