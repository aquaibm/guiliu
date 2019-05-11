//
//  BHostCellView+Delete.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/3/22.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension BHostCellView {
    @objc func deleteAction() {
        guard let item = bhost else {
            return
        }
        ctrller?.deleteBlockedHost(item)

        //标记删除中
        deleteBtn.isHidden = true
        spinIndicator.startAnimation(nil)
    }
}
