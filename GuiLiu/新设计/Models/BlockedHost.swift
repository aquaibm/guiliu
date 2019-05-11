//
//  BlockedHost.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/8/7.
//  Copyright © 2018年 Moonlight. All rights reserved.
//

import Foundation


struct BlockedHost: Codable,Equatable{
    var id: Int?
    var ownerID: Int
    var blockedHost: String
    
    var createdAt: String?
    var updatedAt: String?
    
    init(ownerID: Int, blockedHost: String) {
        self.ownerID = ownerID
        self.blockedHost = blockedHost
    }
    
    static func == (lhs: BlockedHost, rhs: BlockedHost) -> Bool {
        return lhs.id == rhs.id
    }
}
