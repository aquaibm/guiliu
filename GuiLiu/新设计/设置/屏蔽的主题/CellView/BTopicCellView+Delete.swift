//
//  BTopicCellView+Delete.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/3/2.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension BTopicCellView {
    @objc func deleteAction() {
        guard let tp = topic else {
            return
        }
        ctrller?.deleteBlockedTopic(tp)

        //标记删除中
        deleteBtn.isHidden = true
        spinIndicator.startAnimation(nil)
    }
}
