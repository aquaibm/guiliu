//
//  Topic.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/6/26.
//  Copyright © 2018年 Moonlight. All rights reserved.
//

import Foundation

struct Topic: Codable,Hashable{
    var id: Int?
    var name: String
    var creatorID: Int
    var description: String?
    var avatar: Data?
    var createdAt: String?
    var updatedAt: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id!)
    }
    
    init(id: Int? = nil, name: String, creatorID: Int, description: String? = nil, avatar: Data? = nil) {
        self.id = id
        self.name = name
        self.creatorID = creatorID
        self.description = description
        self.avatar = avatar
    }
}
