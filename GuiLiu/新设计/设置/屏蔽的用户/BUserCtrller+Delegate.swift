//
//  BUserCtrller+Delegate.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/1/29.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit


extension BUserCtrller: NSTableViewDelegate,NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return listArray.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView = tableView.makeView(withIdentifier: .BUserCellView, owner: nil) as! BUserCellView
        cellView.ctrller = self
        cellView.update(with: listArray[row])

        //判断是否正在删除中
        let tp = listArray[row]
        let isContained = deletingArray.contains(where: { (localTopic) -> Bool in
            return localTopic.id == tp.id
        })
        if isContained == true {
            cellView.deleteBtn.isHidden = true
            cellView.spinIndicator.startAnimation(nil)
        }
        else {
            cellView.deleteBtn.isHidden = false
            cellView.spinIndicator.stopAnimation(nil)
        }
        return cellView
    }
}
