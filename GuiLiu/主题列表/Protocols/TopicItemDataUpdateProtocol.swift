//
//  TopicItemProtocol.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/12/6.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit

protocol TopicItemDataUpdateProtocol: TopicItemViewLayoutProtocol {
    var topic: Topic? {get set}
}

extension TopicItemDataUpdateProtocol where Self : NSCollectionViewItem {
    func updateWith(tp: Topic) {
        OperationQueue.main.addOperation {
            self.topic = tp

            self.desLabel.stringValue = tp.description ?? ""
            self.titleLabel.stringValue = tp.name

            if let avatar = tp.avatar {
                let image = NSImage(data: avatar)
                self.imageV.layer?.contents = image
            }
            else {
                self.imageV.layer?.contents = nil
            }
        }
    }
}
