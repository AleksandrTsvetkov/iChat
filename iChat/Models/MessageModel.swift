//
//  MessageModel.swift
//  iChat
//
//  Created by Александр Цветков on 29.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

struct MessageModel: Hashable {
    let content: String
    let senderId: String
    let senderUsername: String
    let sendingDate: Date
    let id: String?
    
    var dictionary: [String: Any] {
        let dict: [String: Any] = [
            "created": sendingDate,
            "senderId": senderId,
            "senderName": senderUsername,
            "content": content
        ]
        return dict
    }
    
    init(user: UserModel, content: String) {
        self.content = content
        self.senderId = user.id
        self.senderUsername = user.username
        self.sendingDate = Date()
        self.id = nil
    }
}
