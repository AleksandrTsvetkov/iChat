//
//  ChatModel.swift
//  iChat
//
//  Created by Александр Цветков on 22.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

struct ChatModel: Hashable, Decodable {
    
    var friendUsername: String
    var friendAvatarImageString: String
    var lastMessage: String
    var friendId: String
    
    internal init(friendUsername: String, friendAvatarImageString: String, lastMessage: String, friendId: String) {
        self.friendUsername = friendUsername
        self.friendAvatarImageString = friendAvatarImageString
        self.lastMessage = lastMessage
        self.friendId = friendId
    }
    
    var dictionary: [String: Any] {
        var dict = ["friendUsername": friendUsername]
        dict["friendAvatarImageString"] = friendAvatarImageString
        dict["friendId"] = friendId
        dict["lastMessage"] = lastMessage
        return dict
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard
            let friendUsername = data["friendUsername"] as? String,
            let friendAvatarImageString = data["friendAvatarImageString"] as? String,
            let lastMessage = data["lastMessage"] as? String,
            let friendId = data["friendId"] as? String
            else { return nil }
        self.friendUsername = friendUsername
        self.friendAvatarImageString = friendAvatarImageString
        self.lastMessage = lastMessage
        self.friendId = friendId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendId)
    }
    
    static func == (lhs: ChatModel, rhs: ChatModel) -> Bool {
        return lhs.friendId == rhs.friendId
    }
}
