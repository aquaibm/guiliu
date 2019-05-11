//
//  BUserCellView+Delete.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/3/22.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension BUserCellView {
    @objc func deleteAction() {
        guard let item = buser else {
            return
        }
        ctrller?.deleteBlockedUser(item)

        //标记删除中
        deleteBtn.isHidden = true
        spinIndicator.startAnimation(nil)
    }
}
