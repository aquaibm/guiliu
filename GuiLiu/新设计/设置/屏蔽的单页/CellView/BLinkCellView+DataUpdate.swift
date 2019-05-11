//
//  BLinkCellView+DataUpdate.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/2/6.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension BLinkCellView {
    func update(with link: BlockedLink) {
        blink = link
        titleLabel.stringValue = link.blockedLink
        if let dateStr = link.createdAt {
            desLabel.stringValue = UTCToLocal(date: dateStr, fromFormat: "yyyy-MM-dd'T'HH:mm:ss'Z'", toFormat: "yyyy-MM-dd a h:mm:ss")
        }
        else {
            desLabel.stringValue = "创建时间未知"
        }
    }
}
