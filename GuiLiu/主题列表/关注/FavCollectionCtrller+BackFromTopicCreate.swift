//
//  FavCollectionCtrller+BackFromTopicCreate.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/2/15.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension FavCollectionCtrller {
    func didBackFromTopicCreate(_ noti: Notification) {
        //任务：获取新创建的主题
        guard let topic = noti.object as? Topic  else {
            return
        }

        topics.insert(topic, at: 0)
        OperationQueue.main.addOperation {
            self.pCollectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
        }
    }
}
