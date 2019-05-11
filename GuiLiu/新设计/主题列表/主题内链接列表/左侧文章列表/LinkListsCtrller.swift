//
//  ArticleListsCtrller.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/10/31.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit


class LinkListsCtrller: NSViewController {
    let pNotiObserverManager = FMNotificationManager()

    @IBOutlet weak var pScrollView: NSScrollView!
    @IBOutlet weak var pTableView: NSTableView!

    var pTopic: Topic?
    weak var pSplitCtrller: LinksSplitCtrller?

    let spin = NSProgressIndicator()
    var pIdentifier: Date?
    var pLinks = SynchronizedArray<Reply>()
    var pToBeRemovedLinks = Set<Reply>() //该删除但是目前正被选中的链接条目，会放进这个数组里，选中状态改变时再删除

    override func viewDidLoad() {
        super.viewDidLoad()

        pTableView.register(NSNib(nibNamed: NSNib.Name("ArticleRowView"), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ArticleRowView"))
        pTableView.register(NSNib(nibNamed: NSNib.Name("ArticleCellView"), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ArticleCellView"))
        pTableView.dataSource = self
        pTableView.delegate = self
        pTableView.backgroundColor = .clear
        pTableView.selectionHighlightStyle = .none

        setupSubviews()
        monitorNotifications()
    }
}
