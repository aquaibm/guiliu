//
//  BlockedLink.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/8/7.
//  Copyright © 2018年 Moonlight. All rights reserved.
//

import Foundation


struct BlockedLink: Codable,Equatable{
    var id: Int?
    var ownerID: Int
    var blockedLink: String
    
    var createdAt: String?
    var updatedAt: String?
    
    init(ownerID: Int, blockedLink: String) {
        self.ownerID = ownerID
        self.blockedLink = blockedLink
    }
    
    static func == (lhs: BlockedLink, rhs: BlockedLink) -> Bool {
        return lhs.id == rhs.id
    }
}
