//
//  FilterCellViewLayoutProtocol.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/3/2.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

protocol FilterCellViewLayoutProtocol: AnyObject {
    var titleLabel: NSTextField {get}
    var desLabel: NSTextField {get}
    var deleteBtn: NSButton {get}
    var spinIndicator: NSProgressIndicator {get}
}


extension FilterCellViewLayoutProtocol where Self: NSTableCellView {
    func setupSubviews() {
        deleteBtn.image = NSImage(named: NSImage.Name("delete"))
        deleteBtn.fixButtonBehavior()
        deleteBtn.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview()
            maker.width.greaterThanOrEqualTo(0)
            maker.centerY.equalToSuperview()
            maker.height.greaterThanOrEqualTo(0)
        }

        spinIndicator.controlSize = .small
        spinIndicator.style = .spinning
        spinIndicator.set(tintColor: NSColor.white)
        spinIndicator.isDisplayedWhenStopped = false
        addSubview(spinIndicator)
        spinIndicator.snp.makeConstraints { (maker) in
            maker.center.equalTo(deleteBtn)
            maker.width.height.greaterThanOrEqualTo(0)
        }

        titleLabel.textColor = NSColor.white
        titleLabel.font = NSFont.boldSystemFont(ofSize: 15)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(deleteBtn.snp.right).offset(20)
            maker.right.equalToSuperview()
            maker.top.equalToSuperview().offset(5)
            maker.height.greaterThanOrEqualTo(0)
        }

        desLabel.textColor = NSColor.gray
        addSubview(desLabel)
        desLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(titleLabel)
            maker.right.equalTo(titleLabel)
            maker.bottom.equalToSuperview().offset(-5)
            maker.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
    }
}
