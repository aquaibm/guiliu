//
//  BrowserCtrller+Delegate.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/11/4.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit
import WebKit

extension BrowserCtrller {
    func setupSubviews() {
        let containerHeight: CGFloat = 100

        pWebView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 12_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0 Mobile/15E148 Safari/604.1"
        view.addSubview(pWebView)
        pWebView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalToSuperview()
            maker.bottom.equalToSuperview()
        }

        //底部面板
        view.addSubview(panelContainer)
        panelContainer.wantsLayer = true
        panelContainer.layer?.backgroundColor = NSColor(white: 0.2, alpha: 0.75).cgColor
        panelContainer.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview()
            maker.height.equalTo(containerHeight)
            maker.left.right.equalToSuperview()
        }

        //加载标志
        spin.style = .spinning
        spin.controlSize = .regular
        spin.set(tintColor: NSColor.gray)
        spin.isDisplayedWhenStopped = false
        view.addSubview(spin)
        spin.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.width.height.greaterThanOrEqualTo(0)
        }

        //底部面板subview
        let mainBox = NSView()
        panelContainer.addSubview(mainBox)

        func configure(_ label: NSTextField) {
            label.textColor = ColorFromRGB(rgbValue: 0xD3D3D3)
            label.font = NSFont.systemFont(ofSize: 12)
            label.cell?.wraps = true
            label.cell?.truncatesLastVisibleLine = false
            label.cell?.alignment = .center
            label.maximumNumberOfLines = 2
        }
        let innerSpace = 50
        let labelWidth = 70

        func attach(spin: NSProgressIndicator, to button: NSButton) {
            spin.style = .spinning
            spin.controlSize = .small
            spin.set(tintColor: NSColor.lightGray)
            spin.isDisplayedWhenStopped = false

            let spView = button.superview!
            spView.addSubview(spin)
            spin.snp.makeConstraints { (maker) in
                maker.center.equalTo(button)
                maker.width.height.greaterThanOrEqualTo(0)
            }
        }

        buserBtn.image = NSImage(named: NSImage.Name("buser"))!
        buserBtn.target = self
        buserBtn.action = #selector(blockUser)
        buserBtn.toolTip = "屏蔽所有来自该用户发布的内容"
        buserBtn.fixButtonBehavior()
        let buserLabel = NSTextField(labelWithString: "屏蔽该用户的内容")
        configure(buserLabel)
        mainBox.addSubview(buserBtn)
        mainBox.addSubview(buserLabel)
        buserBtn.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(20)
            maker.width.greaterThanOrEqualTo(0)
            maker.top.equalToSuperview()
            maker.height.greaterThanOrEqualTo(0)
        }
        buserLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(buserBtn)
            maker.width.equalTo(labelWidth)
            maker.top.equalTo(buserBtn.snp.bottom).offset(10)
            maker.bottom.equalToSuperview()
            maker.height.greaterThanOrEqualTo(0)
        }
        attach(spin: buserSpin, to: buserBtn)


        bhostBtn.image = NSImage(named: NSImage.Name("bhost"))!
        bhostBtn.target = self
        bhostBtn.action = #selector(blockHost)
        bhostBtn.toolTip = "屏蔽所有来自该网站的内容"
        bhostBtn.fixButtonBehavior()
        let bhostLabel = NSTextField(labelWithString: "屏蔽该网站的内容")
        configure(bhostLabel)
        mainBox.addSubview(bhostBtn)
        mainBox.addSubview(bhostLabel)
        bhostBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(buserBtn.snp.right).offset(innerSpace)
            maker.width.greaterThanOrEqualTo(0)
            maker.top.equalToSuperview()
            maker.height.greaterThanOrEqualTo(0)
        }
        bhostLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(bhostBtn)
            maker.width.equalTo(labelWidth)
            maker.top.equalTo(bhostBtn.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }
        attach(spin: bhostSpin, to: bhostBtn)

        blinkBtn.image = NSImage(named: NSImage.Name("blink"))!
        blinkBtn.target = self
        blinkBtn.action = #selector(blockLink)
        blinkBtn.toolTip = "屏蔽该链接的内容"
        blinkBtn.fixButtonBehavior()
        let blinkLabel = NSTextField(labelWithString: "屏蔽该网址的内容")
        configure(blinkLabel)
        mainBox.addSubview(blinkBtn)
        mainBox.addSubview(blinkLabel)
        blinkBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(bhostBtn.snp.right).offset(innerSpace)
            maker.width.greaterThanOrEqualTo(0)
            maker.top.equalToSuperview()
            maker.height.greaterThanOrEqualTo(0)
        }
        blinkLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(blinkBtn)
            maker.width.equalTo(labelWidth)
            maker.top.equalTo(blinkBtn.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }
        attach(spin: blinkSpin, to: blinkBtn)

        illegalBtn.image = NSImage(named: NSImage.Name("illegal"))!
        illegalBtn.target = self
        illegalBtn.action = #selector(illegalReport)
        illegalBtn.toolTip = "屏蔽该链接的内容，且报告该内容非法"
        illegalBtn.fixButtonBehavior()
        let illegalLabel = NSTextField(labelWithString: "举报非法内容")
        configure(illegalLabel)
        mainBox.addSubview(illegalBtn)
        mainBox.addSubview(illegalLabel)
        illegalBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(blinkBtn.snp.right).offset(innerSpace)
            maker.width.greaterThanOrEqualTo(0)
            maker.top.equalToSuperview()
            maker.height.greaterThanOrEqualTo(0)
        }
        illegalLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(illegalBtn)
            maker.width.equalTo(labelWidth)
            maker.top.equalTo(illegalBtn.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }
        attach(spin: illegalSpin, to: illegalBtn)


        let safariBtn = NSButton(image: NSImage(named: NSImage.Name("safari"))!, target: self, action: #selector(openInSafari))
        safariBtn.fixButtonBehavior()
        let safariLabel = NSTextField(labelWithString: "在浏览器中打开")
        configure(safariLabel)
        mainBox.addSubview(safariBtn)
        mainBox.addSubview(safariLabel)
        safariBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(illegalBtn.snp.right).offset(innerSpace)
            maker.width.greaterThanOrEqualTo(0)
            maker.right.equalToSuperview().offset(-20)
            maker.top.equalToSuperview()
            maker.height.greaterThanOrEqualTo(0)
        }
        safariLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(safariBtn)
            maker.width.equalTo(labelWidth)
            maker.top.equalTo(safariBtn.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }

        mainBox.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
        }
    }

}
