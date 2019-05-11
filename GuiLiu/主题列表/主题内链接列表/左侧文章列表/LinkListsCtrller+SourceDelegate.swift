//
//  ArticleListsCtrller+SourceDelegate.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/10/31.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit


extension LinkListsCtrller: NSTableViewDelegate,NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return pLinks.count
    }

    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        return tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init("ArticleRowView"), owner: nil) as! ArticleRowView
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init("ArticleCellView"), owner: nil) as! ArticleCellView
        cellView.updateWith(reply: pLinks[row]!)
        return cellView
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 50
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        let row = pTableView.selectedRow
        guard row != -1 else {return}
        let browserCtr = pSplitCtrller?.pBrowserCtrller
        browserCtr?.updateWith(article: pLinks[row]!)

        //针对之前被选中，但是要清理尚未清理的条目
        for _ in 0..<pToBeRemovedLinks.count {
            if let first = pToBeRemovedLinks.first,let index = pLinks.index(where:{$0.id == first.id}) {
                pToBeRemovedLinks.remove(first)
                pLinks.remove(at: index)
                pTableView.removeRows(at: IndexSet.init(integer: index), withAnimation: .effectFade)
            }
        }
    }
}
