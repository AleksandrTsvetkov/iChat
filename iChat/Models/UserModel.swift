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
    var id: String
    var email: String
    var description: String
    var sex: String
    
    var dictionary: Dictionary<String, String> {
        var dict = ["username": username]
        dict["sex"] = sex
        dict["email"] = email
        dict["avatarStringURL"] = avatarStringURL
        dict["description"] = description
        dict["uid"] = id
        return dict
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func contains(filter: String?) -> Bool {
        guard let filter = filter else { return true }
        if filter.isEmpty { return true }
        let lowerCasedFilter = filter.lowercased()
        return username.lowercased().contains(lowerCasedFilter)
    }
}
