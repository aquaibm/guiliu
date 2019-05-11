//
//  TopicSplitCtrller+BackFromPostArticle.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/11/17.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension LinksSplitCtrller {
    func didBackFromLinkPost(noti: Notification) {
        guard let type = noti.object as? LinkPostCtrller.BackType  else {
            return
        }
        if type == .submit {
            pListsCtrller.getNewerReplies()
        }
    }
}
