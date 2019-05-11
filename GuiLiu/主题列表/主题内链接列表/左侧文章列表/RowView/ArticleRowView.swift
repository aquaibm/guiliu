//
//  ArticleRowView.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/12/2.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit

class ArticleRowView: NSTableRowView {
    let pHighlightView = NSView()

    override var isSelected: Bool {
        didSet {
            OperationQueue.main.addOperation {
                self.pHighlightView.isHidden = !(self.isSelected)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setupSubviews()
    }
}
