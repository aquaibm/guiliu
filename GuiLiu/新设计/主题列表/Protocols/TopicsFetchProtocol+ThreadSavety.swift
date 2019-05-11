//
//  TopicsFetchProtocol+ThreadSavety.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/3/15.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension TopicsFetchProtocol {
    func addTopic(_ topic: Topic) {
        //You dispatch the write operation asynchronously with a barrier. When it executes, it will be the only item in your queue.
        concurrentTopicsQueue.async(qos: .userInitiated, flags: .barrier) { [weak self] in
            guard let self = self else {
                return
            }

            let index = self.topics.endIndex
            self.topics.append(topic)
            DispatchQueue.main.async(execute: {
                self.pCollectionView.insertItems(at: [IndexPath(item: index, section: 0)])
            })
        }
    }

    func getTopics() -> [Topic] {
        var copy: [Topic]!
        concurrentTopicsQueue.sync {
            copy = topics
        }
        return copy
    }

    func removeAllTopic() {
        concurrentTopicsQueue.async(qos: .userInitiated, flags: .barrier) { [weak self] in
            guard let self = self else {
                return
            }

            self.topics.removeAll()
            DispatchQueue.main.async(execute: {
                self.pCollectionView.reloadData()
            })
        }
    }
}
