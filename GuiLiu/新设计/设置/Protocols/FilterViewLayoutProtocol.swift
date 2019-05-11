//
//  FilterViewLayoutProtocol.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/1/28.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit


protocol FilterViewLayoutProtocol: AnyObject {
    var tipLabel: NSTextField {get}
    var scrollView: NSScrollView! {get set}
    var tableView: NSTableView! {get set}
    var leftBtn: NSButton {get}
    var rightBtn: NSButton {get}
    var spin: NSProgressIndicator {get}
    var bottomTipLabel: NSTextField {get}
}


extension FilterViewLayoutProtocol where Self: NSViewController & NSTableViewDelegate & NSTableViewDataSource {
    func layoutFilterView() {
        let mainColor = NSColor(white: 0.85, alpha: 1.0)
        let horizontalSpace = 50

        tipLabel.textColor = mainColor
        view.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(horizontalSpace)
            maker.width.greaterThanOrEqualTo(0)
            maker.top.equalToSuperview().offset(30)
            maker.height.greaterThanOrEqualTo(0)
        }

        tableView.backgroundColor = .clear
        tableView.selectionHighlightStyle = .none
        tableView.delegate = self
        tableView.dataSource = self

        scrollView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(horizontalSpace)
            maker.right.equalToSuperview().offset(-horizontalSpace)
            maker.top.equalTo(tipLabel.snp.bottom).offset(20)
            maker.bottom.equalToSuperview().offset(-100)
        }

        leftBtn.image = NSImage(named: NSImage.Name("leftPage"))
        leftBtn.toolTip = "前一页"
        leftBtn.fixButtonBehavior()
        view.addSubview(leftBtn)
        leftBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(tipLabel)
            maker.width.equalTo(40)
            maker.top.equalTo(scrollView.snp.bottom).offset(20)
            maker.height.equalTo(30)
        }

        rightBtn.image = NSImage(named: NSImage.Name("rightPage"))
        rightBtn.toolTip = "下一页"
        rightBtn.fixButtonBehavior()
        view.addSubview(rightBtn)
        rightBtn.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(-horizontalSpace)
            maker.width.equalTo(leftBtn)
            maker.top.equalTo(leftBtn)
            maker.height.equalTo(leftBtn)
        }

        //翻页提示
        bottomTipLabel.font = NSFont.systemFont(ofSize: 14)
        bottomTipLabel.textColor = NSColor.lightGray
        view.addSubview(bottomTipLabel)
        bottomTipLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.centerY.equalTo(leftBtn)
        }

        //加载标志
        spin.controlSize = .small
        spin.style = .spinning
        spin.set(tintColor: NSColor.white)
        spin.isDisplayedWhenStopped = false
        view.addSubview(spin)
        spin.snp.makeConstraints { (maker) in
            maker.width.height.greaterThanOrEqualTo(0)
            maker.left.equalTo(tipLabel.snp.right).offset(20)
            maker.centerY.equalTo(tipLabel)
        }
    }
}
