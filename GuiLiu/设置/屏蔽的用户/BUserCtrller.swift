//
//  BUserCtrller.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/1/29.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit


class BUserCtrller: NSViewController,FilterListsProtocol {

    typealias Item = BlockedUser

    let tipLabel = NSTextField(labelWithString: "获取数据中...")
    let spin = NSProgressIndicator()
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var tableView: NSTableView!
    let leftBtn = NSButton()
    let rightBtn = NSButton()
    let bottomTipLabel = NSTextField(labelWithString: "")

    var listArray = [BlockedUser]()
    var deletingArray = [BlockedUser]()
    var totalCounts: Int?
    var currentPage = 0
    var isFetching = false
    var isFetched = false
    let countRoute = "countofblockedusers"
    let listsRoute = "blockedusers"

    override func viewDidLoad() {
        super.viewDidLoad()

        layoutFilterView()
        tableView.register(NSNib(nibNamed: NSNib.Name("BUserCellView"), bundle: nil), forIdentifier: .BUserCellView)

        getListCounts()
        getBlockedListOf(page: 0)
        setupPageButton()
    }
}
