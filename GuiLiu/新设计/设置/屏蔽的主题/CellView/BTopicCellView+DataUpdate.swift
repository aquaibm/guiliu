//
//  BTopicCellView+DataUpdate.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/1/29.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension BTopicCellView {
    func update(with tp: BlockedTopic) {
        topic = tp
        titleLabel.stringValue = tp.blockedTopicName
        if let dateStr = tp.createdAt {
            desLabel.stringValue = UTCToLocal(date: dateStr, fromFormat: "yyyy-MM-dd'T'HH:mm:ss'Z'", toFormat: "yyyy-MM-dd a h:mm:ss")
        }
        else {
            desLabel.stringValue = "创建时间未知"
        }
    }
}
