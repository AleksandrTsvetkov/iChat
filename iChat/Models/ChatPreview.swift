//
//  ChatPreview.swift
//  iChat
//
//  Created by Александр Цветков on 22.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

struct ChatPreview: Hashable, Decodable {
    var username: String
    var userImageString: String
    var lastMessage: String
    var id: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ChatPreview, rhs: ChatPreview) -> Bool {
        return lhs.id == rhs.id
    }
}
