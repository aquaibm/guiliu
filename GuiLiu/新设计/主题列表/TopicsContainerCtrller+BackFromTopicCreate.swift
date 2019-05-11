//
//  AppDelegate+BackFromTopicCreate.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/12/16.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit


extension TopicsContainerCtrller {
    func didBackFromTopicCreate(_ noti: Notification) {
        //任务：获取新创建的主题
        guard let _ = noti.object as? Topic  else {
            return
        }
        presentFavCtrller()
    }
}
