//
//  BTopicCtrller.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/1/27.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

class BTopicCtrller: NSViewController,FilterListsProtocol {

    typealias Item = BlockedTopic

    let tipLabel = NSTextField(labelWithString: "获取数据中...")
    let spin = NSProgressIndicator()
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var tableView: NSTableView!
    let leftBtn = NSButton()
    let rightBtn = NSButton()
    let bottomTipLabel = NSTextField(labelWithString: "")

    var listArray = [BlockedTopic]()
    var deletingArray = [BlockedTopic]()
    var totalCounts: Int?
    var currentPage = 0
    var isFetching = false
    var isFetched = false
    let countRoute = "countofblockedtopics"
    let listsRoute = "blockedtopics"

    override func viewDidLoad() {
        super.viewDidLoad()

        layoutFilterView()
        tableView.register(NSNib(nibNamed: NSNib.Name("BTopicCellView"), bundle: nil), forIdentifier: .BTopicCellView)

        getListCounts()
        getBlockedListOf(page: 0)
        setupPageButton()
    }
}
