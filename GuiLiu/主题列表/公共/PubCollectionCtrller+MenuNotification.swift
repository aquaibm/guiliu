//
//  PubCollectionCtrller+MenuNotification.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/2/7.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension PubCollectionCtrller {
    func handleUnsubscribeTopic(_ noti: Notification) {
        guard let topic = noti.object as? Topic else {
            return
        }

        topics.insert(topic, at: 0)
        OperationQueue.main.addOperation {
            self.pCollectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
        }
    }

    func didSubscribeTopic(_ noti: Notification) {
        guard let topic = noti.object as? Topic else {
            return
        }

        guard let i = topics.firstIndex(of: topic) else {
            return
        }

        topics.remove(at: i)

        pCollectionView.deleteItems(at: [IndexPath(item: i, section: 0)])
    }

    func didBlockTopic(_ noti: Notification) {
        guard let topic = noti.object as? Topic else {
            return
        }

        guard let i = topics.firstIndex(of: topic) else {
            return
        }

        topics.remove(at: i)

        pCollectionView.deleteItems(at: [IndexPath(item: i, section: 0)])
    }

    func didEditTopic(_ noti: Notification) {
        guard let tp = noti.object as? Topic  else {
            return
        }

        guard let index = topics.firstIndex(where: { topic -> Bool in return topic.id! == tp.id!}) else {
            return
        }

        self.topics[index] = tp
        self.pCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }

    func didDeleteTopic(_ noti: Notification) {
        guard let tp = noti.object as? Topic  else {
            return
        }

        guard let index = topics.firstIndex(where: { topic -> Bool in return topic.id! == tp.id!}) else {
            return
        }

        self.topics.remove(at: index)
        self.pCollectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
    }
}
