//
//  LinkListsCtrller+Subviews.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/3/18.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension LinkListsCtrller {
    func setupSubviews() {
        let naviHeight = 50
        pTableView.allowsEmptySelection = false
        pScrollView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-naviHeight)
        }

        let navigationView = NSView()
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalToSuperview()
            maker.height.equalTo(naviHeight)
        }

        let newestBtn = NSButton(image: NSImage(named: NSImage.Name("newest"))!, target: nil, action: nil)
        newestBtn.fixButtonBehavior()
        newestBtn.toolTip = "转到最新内容顶部"
        newestBtn.target = self
        newestBtn.action = #selector(getFirstBatchReplies)
        navigationView.addSubview(newestBtn)
        newestBtn.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(10)
            maker.width.greaterThanOrEqualTo(0)
            maker.centerY.equalToSuperview()
            maker.height.greaterThanOrEqualTo(0)
        }

        let newerBtn = NSButton(image: NSImage(named: NSImage.Name("newer"))!, target: nil, action: nil)
        newerBtn.fixButtonBehavior()
        newerBtn.toolTip = "上一页"
        newerBtn.target = self
        newerBtn.action = #selector(getNewerReplies)
        navigationView.addSubview(newerBtn)
        newerBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(newestBtn.snp.right).offset(10)
            maker.width.greaterThanOrEqualTo(0)
            maker.centerY.equalToSuperview()
            maker.height.greaterThanOrEqualTo(0)
        }

        let olderBtn = NSButton(image: NSImage(named: NSImage.Name("older"))!, target: nil, action: nil)
        olderBtn.fixButtonBehavior()
        olderBtn.toolTip = "下一页"
        olderBtn.target = self
        olderBtn.action = #selector(getOlderReplies)
        navigationView.addSubview(olderBtn)
        olderBtn.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(-10)
            maker.width.greaterThanOrEqualTo(0)
            maker.centerY.equalToSuperview()
            maker.height.greaterThanOrEqualTo(0)
        }

        let spinContainer = NSView()
        navigationView.addSubview(spinContainer)
        spinContainer.snp.makeConstraints { (maker) in
            maker.left.equalTo(newerBtn.snp.right)
            maker.right.equalTo(olderBtn.snp.left)
            maker.top.bottom.equalToSuperview()
        }
        spin.style = .spinning
        spin.controlSize = .small
        spin.set(tintColor: NSColor.white)
        spin.isDisplayedWhenStopped = false
        spinContainer.addSubview(spin)
        spin.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.width.height.greaterThanOrEqualTo(0)
        }
    }
}
