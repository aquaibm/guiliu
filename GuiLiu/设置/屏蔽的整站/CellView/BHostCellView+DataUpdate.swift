//
//  BHostCellView+DataUpdate.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/2/4.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension BHostCellView {
    func update(with host: BlockedHost) {
        bhost = host
        titleLabel.stringValue = host.blockedHost
        if let dateStr = host.createdAt {
            desLabel.stringValue = UTCToLocal(date: dateStr, fromFormat: "yyyy-MM-dd'T'HH:mm:ss'Z'", toFormat: "yyyy-MM-dd a h:mm:ss")
        }
        else {
            desLabel.stringValue = "创建时间未知"
        }
    }
}
