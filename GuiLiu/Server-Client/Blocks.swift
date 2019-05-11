//
//  BlockedUser.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/7/29.
//  Copyright © 2018年 Moonlight. All rights reserved.
//

import Foundation


struct Blocks: Codable {
    var ownerID: Int
    
    var blockedUserID: Int?
    var blockedHost: String?
    var blockedLink: String?
    var isOffensive: Bool?
}
