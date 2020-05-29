//
//  UserModel.swift
//  iChat
//
//  Created by Александр Цветков on 24.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

struct UserModel: Hashable, Decodable {
    
    //MARK: PROPERTIES
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
    
    //MARK: INITIALIZERS
    internal init(username: String, avatarStringURL: String, id: String, email: String, description: String, sex: String) {
        self.username = username
        self.avatarStringURL = avatarStringURL
        self.id = id
        self.email = email
        self.description = description
        self.sex = sex
    }
    
    init?(document: DocumentSnapshot) {
        guard
            let data = document.data(),
            let username = data["username"] as? String,
            let email = data["email"] as? String,
            let avatarStringURL = data["avatarStringURL"] as? String,
            let description = data["description"] as? String,
            let sex = data["sex"] as? String,
            let id = data["uid"] as? String
            else { return nil }
        self.username = username
        self.email = email
        self.avatarStringURL = avatarStringURL
        self.description = description
        self.sex = sex
        self.id = id
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard
            let username = data["username"] as? String,
            let email = data["email"] as? String,
            let avatarStringURL = data["avatarStringURL"] as? String,
            let description = data["description"] as? String,
            let sex = data["sex"] as? String,
            let id = data["uid"] as? String
            else { return nil }
        self.username = username
        self.email = email
        self.avatarStringURL = avatarStringURL
        self.description = description
        self.sex = sex
        self.id = id
    }
    
    //MARK: METHODS
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
