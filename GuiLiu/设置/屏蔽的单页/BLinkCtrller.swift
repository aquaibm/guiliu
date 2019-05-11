//
//  BLinkCtrller.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/2/6.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit


class BLinkCtrller: NSViewController,FilterListsProtocol {

    typealias Item = BlockedLink

    let tipLabel = NSTextField(labelWithString: "获取数据中...")
    let spin = NSProgressIndicator()
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var tableView: NSTableView!
    let leftBtn = NSButton()
    let rightBtn = NSButton()
    let bottomTipLabel = NSTextField(labelWithString: "")

    var listArray = [BlockedLink]()
    var deletingArray = [BlockedLink]()
    var totalCounts: Int?
    var currentPage = 0
    var isFetching = false
    var isFetched = false
    let countRoute = "countofblockedlinks"
    let listsRoute = "blockedlinks"

    override func viewDidLoad() {
        super.viewDidLoad()

        layoutFilterView()
        tableView.register(NSNib(nibNamed: NSNib.Name("BLinkCellView"), bundle: nil), forIdentifier: .BLinkCellView)

        getListCounts()
        getBlockedListOf(page: 0)
        setupPageButton()
    }
}
