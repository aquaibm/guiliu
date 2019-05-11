//
//  PublicCtrller+DataFetching.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/10/27.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit


extension PubCollectionCtrller {

    @objc func getPreviousPage() {
        guaranteeSearchStringConsistency()
        guard batchNumber > 0 else {
            showTipMessage("已经到达首页") 
            return
        }

        fetchTopicsOf(batchNumber-1)
    }

    @objc func getNextPage() {
        guaranteeSearchStringConsistency()
        //确保页数不大于最大值
        if let max = pagesCount, batchNumber >= max {
            showTipMessage("已经是最后一页")
            return
        }
        fetchTopicsOf(batchNumber+1)
    }

    func guaranteeSearchStringConsistency() {
        //如果用户输入关键词但是没回车激活对应的搜索，则重置为当前关键词，以免误导用户
        if searchString != searchView.searchString {
            searchView.searchString = searchString
        }
    }
}
