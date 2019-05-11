//
//  User.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/6/10.
//  Copyright © 2018年 Moonlight. All rights reserved.
//

import Foundation

struct User: Codable {
    var id: Int?
    
    var email: String
    var password: String
    
    var nickName: String?
    var cellPhone: String?
    var avatar: Data?
    
    var createdAt: String?
    var updatedAt: String?
    
    init(id: Int? = nil, email: String, password: String, cellPhone: String = "", avatar: Data? = nil) {
        self.id = id
        self.email = email
        self.password = password
        self.cellPhone = cellPhone
        self.avatar = avatar
    }
}
