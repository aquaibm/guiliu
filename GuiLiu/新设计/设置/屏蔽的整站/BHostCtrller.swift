//
//  BHostCtrller.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/2/4.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit


class BHostCtrller: NSViewController,FilterListsProtocol {

    typealias Item = BlockedHost

    let tipLabel = NSTextField(labelWithString: "获取数据中...")
    let spin = NSProgressIndicator()
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var tableView: NSTableView!
    let leftBtn = NSButton()
    let rightBtn = NSButton()
    let bottomTipLabel = NSTextField(labelWithString: "")

    var listArray = [BlockedHost]()
    var deletingArray = [BlockedHost]()
    var totalCounts: Int?
    var currentPage = 0
    var isFetching = false
    var isFetched = false
    let countRoute = "countofblockedhosts"
    let listsRoute = "blockedhosts"

    override func viewDidLoad() {
        super.viewDidLoad()

        layoutFilterView()
        tableView.register(NSNib(nibNamed: NSNib.Name("BHostCellView"), bundle: nil), forIdentifier: .BHostCellView)

        getListCounts()
        getBlockedListOf(page: 0)
        setupPageButton()
    }
}
