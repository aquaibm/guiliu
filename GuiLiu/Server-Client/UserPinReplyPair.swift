//
//  UserReplyPair.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/7/4.
//  Copyright © 2018年 Moonlight. All rights reserved.
//

import Foundation

struct UserPinReplyPair: Codable {
    var userID: Int
    var replyID: Int
    var interactionType: Int  //1 = like, 2 = dislike, 0 = none
}
