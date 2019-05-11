//
//  BTopicCtrller+Page.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/2/15.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension BTopicCtrller {

    func setupPageButton() {
        leftBtn.target = self
        leftBtn.action = #selector(previousPage)

        rightBtn.target = self
        rightBtn.action = #selector(nextPage)
    }

    @objc func previousPage() {
        guard currentPage > 0 else {
            showTipMessage("已经到达首页")
            return
        }
        getBlockedListOf(page: currentPage-1)
    }

    @objc func nextPage() {
        //确保页数不大于最大值
        if let max = totalCounts, currentPage >= max/50 {
            showTipMessage("已经是最后一页")
            return
        }

        getBlockedListOf(page: currentPage+1)
    }
}
