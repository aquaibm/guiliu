//
//  BlockedUser.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/8/7.
//  Copyright © 2018年 Moonlight. All rights reserved.
//

import Foundation

struct BlockedUser: Codable,Equatable{
    var id: Int?
    var ownerID: Int
    var blockedUserID: Int
    var blockedUserName: String?
    
    var createdAt: String?
    var updatedAt: String?
    
    init(ownerID: Int, blockedUserID: Int) {
        self.ownerID = ownerID
        self.blockedUserID = blockedUserID
    }
    
    static func == (lhs: BlockedUser, rhs: BlockedUser) -> Bool {
        return lhs.id == rhs.id
    }
}
