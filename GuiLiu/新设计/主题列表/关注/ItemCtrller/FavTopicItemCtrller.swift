//
//  TopicItemFavCtrller.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/12/6.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit

class FavTopicItemCtrller: NSCollectionViewItem,TopicItemDataUpdateProtocol,TopicItemMenuProtocol {
    var topic: Topic?

    let desLabel = NSTextField(labelWithString: "")
    let titleLabel = NSTextField(labelWithString: "")
    let imageV = NSView(frame: .zero)
    let effectView = CMMenuVisualView()
    let pHighlightView = NSView()
    var trackArea: NSTrackingArea?
    let pMenu = NSMenu(title: "操作")
    let spin = NSProgressIndicator()

    override func viewDidLoad() {
        super.viewDidLoad()

        layoutTopicView(on: view)
        setupMenu()
        setupProgressIndicator()
    }
}
