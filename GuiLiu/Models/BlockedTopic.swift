//
//  BlockedTopics.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/8/20.
//  Copyright © 2018年 Moonlight. All rights reserved.
//

import Foundation


struct BlockedTopic: Codable,Equatable {
    var id: Int?
    var ownerID: Int
    var blockedTopicID: Int
    var blockedTopicName: String
    
    var createdAt: String?
    var updatedAt: String?
    
    init(ownerID: Int, blockedTopicID: Int, blockedTopicName: String) {
        self.ownerID = ownerID
        self.blockedTopicID = blockedTopicID
        self.blockedTopicName = blockedTopicName
    }
    
    static func == (lhs: BlockedTopic, rhs: BlockedTopic) -> Bool {
        return lhs.id == rhs.id
    }
}
