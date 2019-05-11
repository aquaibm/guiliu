//
//  WarningCellView.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/9/3.
//  Copyright © 2018年 Moonlight. All rights reserved.
//

import Foundation
import AppKit

class WarningCellView: NSTableCellView {
    
    let pMessageLabel = NSTextField(labelWithString: "")
    var pMessageText: String? {
        didSet {
            OperationQueue.main.addOperation {
                self.pMessageLabel.stringValue = self.pMessageText ?? ""
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pMessageLabel.textColor = NSColor.white
        pMessageLabel.cell?.wraps = true
        pMessageLabel.cell?.truncatesLastVisibleLine = true
        pMessageLabel.maximumNumberOfLines = 3
        pMessageLabel.font = NSFont.systemFont(ofSize: 12)
        addSubview(pMessageLabel)
        pMessageLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.lessThanOrEqualTo(300)
            maker.top.equalToSuperview().offset(5)
            maker.bottom.equalToSuperview().offset(-5)
        }
    }
}
