//
//  BLinkCellView.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/2/6.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

class BLinkCellView: NSTableCellView,FilterCellViewLayoutProtocol {

    let titleLabel = NSTextField(labelWithString: "主题")
    let desLabel = NSTextField(labelWithString: "描述")
    let deleteBtn = NSButton()
    let spinIndicator = NSProgressIndicator()

    weak var ctrller: BLinkCtrller?
    var blink: BlockedLink?

    override func awakeFromNib() {
        super.awakeFromNib()

        setupSubviews()
        deleteBtn.target = self
        deleteBtn.action = #selector(deleteAction)
    }
}

extension NSUserInterfaceItemIdentifier {
    static let BLinkCellView = NSUserInterfaceItemIdentifier("BLinkCellView")
}
