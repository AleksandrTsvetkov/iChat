//
//  UserModel.swift
//  iChat
//
//  Created by Александр Цветков on 24.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

struct UserModel: Hashable, Decodable {
    var username: String
    var avatarStringURL: String
    var id: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        return lhs.id == rhs.id
    }
}
