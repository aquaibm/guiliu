//
//  BHostCellView.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/2/4.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

class BHostCellView: NSTableCellView,FilterCellViewLayoutProtocol {

    let titleLabel = NSTextField(labelWithString: "主题")
    let desLabel = NSTextField(labelWithString: "描述")
    let deleteBtn = NSButton()
    let spinIndicator = NSProgressIndicator()

    weak var ctrller: BHostCtrller?
    var bhost: BlockedHost?

    override func awakeFromNib() {
        super.awakeFromNib()

        setupSubviews()
        deleteBtn.target = self
        deleteBtn.action = #selector(deleteAction)
    }
}

extension NSUserInterfaceItemIdentifier {
    static let BHostCellView = NSUserInterfaceItemIdentifier("BHostCellView")
}
