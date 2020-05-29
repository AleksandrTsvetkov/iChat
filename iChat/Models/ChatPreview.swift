//
//  ChatPreview.swift
//  iChat
//
//  Created by Александр Цветков on 22.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

struct ChatPreview: Hashable, Decodable {
    var friendUsername: String
    var friendAvatarImageString: String
    var lastMessage: String
    var friendId: String
    
    var dictionary: [String: Any] {
        var dict = ["friendUsername": friendUsername]
        dict["friendAvatarImageString"] = friendAvatarImageString
        dict["friendId"] = friendId
        dict["lastMessage"] = lastMessage
        return dict
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendId)
    }
    
    static func == (lhs: ChatPreview, rhs: ChatPreview) -> Bool {
        return lhs.friendId == rhs.friendId
    }
}
