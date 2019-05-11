//
//  UserProfile.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/9/17.
//  Copyright © 2018年 Moonlight. All rights reserved.
//

import Foundation

struct UserProfile: Codable {
    var userID: Int
    var userNickName: String?
    
    var userPWord: String?
    var userNewPWord: String?

    init(id: Int, nickname: String? = nil, pword: String? = nil, newPword: String? = nil) {
        self.userID = id
        self.userNickName = nickname
        self.userPWord = pword
        self.userNewPWord = newPword
    }
}
