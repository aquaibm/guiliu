//
//  BLinkCellView+Delete.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/3/22.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension BLinkCellView {
    @objc func deleteAction() {
        guard let item = blink else {
            return
        }
        ctrller?.deleteBlockedLink(item)

        //标记删除中
        deleteBtn.isHidden = true
        spinIndicator.startAnimation(nil)
    }
}
