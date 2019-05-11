//
//  ArticleCellView.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/10/31.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit

class ArticleCellView: NSTableCellView {

    var pReply: Reply?

    let pTitleField = NSTextField(labelWithString: "")
    let pSummaryLabel = NSTextField(labelWithString: "")

    override func awakeFromNib() {
        super.awakeFromNib()

        setupSubviews()
    }

    func updateWith(reply: Reply) {
        pTitleField.stringValue = reply.title
        pSummaryLabel.stringValue = reply.summary

        pReply = reply
    }

}
