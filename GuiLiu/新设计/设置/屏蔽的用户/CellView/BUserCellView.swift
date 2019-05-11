//
//  BUserCellView.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/1/29.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

class BUserCellView: NSTableCellView,FilterCellViewLayoutProtocol {

    let titleLabel = NSTextField(labelWithString: "主题")
    let desLabel = NSTextField(labelWithString: "描述")
    let deleteBtn = NSButton()
    let spinIndicator = NSProgressIndicator()

    weak var ctrller: BUserCtrller?
    var buser: BlockedUser?

    override func awakeFromNib() {
        super.awakeFromNib()

        setupSubviews()
        deleteBtn.target = self
        deleteBtn.action = #selector(deleteAction)
    }
}

extension NSUserInterfaceItemIdentifier {
    static let BUserCellView = NSUserInterfaceItemIdentifier("BUserCellView")
}
