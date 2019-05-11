//
//  SettingsCtrller+Subviews.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/1/5.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension SettingsCtrller {
    func setupBarView() {
        func customizeButton(_ button: NSButton) {
            let dict = [NSAttributedString.Key.foregroundColor: NSColor.white]
            let attStr = NSAttributedString(string: button.title, attributes: dict)
            button.attributedTitle = attStr
        }

        accountBtn.fixButtonBehavior()
        customizeButton(accountBtn)
        accountBtn.target = self
        accountBtn.action = #selector(accountAction)
        barView.addSubview(accountBtn)
        accountBtn.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview()
            maker.width.greaterThanOrEqualTo(0)
            maker.centerY.equalToSuperview()
            maker.height.equalToSuperview()
        }

        bTopicBtn.fixButtonBehavior()
        customizeButton(bTopicBtn)
        bTopicBtn.target = self
        bTopicBtn.action = #selector(bTopicAction)
        barView.addSubview(bTopicBtn)
        bTopicBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(accountBtn.snp.right).offset(20)
            maker.width.greaterThanOrEqualTo(0)
            maker.centerY.equalToSuperview()
            maker.height.equalToSuperview()
        }

        bUserBtn.fixButtonBehavior()
        customizeButton(bUserBtn)
        bUserBtn.target = self
        bUserBtn.action = #selector(bUserAction)
        barView.addSubview(bUserBtn)
        bUserBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(bTopicBtn.snp.right).offset(20)
            maker.width.greaterThanOrEqualTo(0)
            maker.centerY.equalToSuperview()
            maker.height.equalToSuperview()
        }

        bHostBtn.fixButtonBehavior()
        customizeButton(bHostBtn)
        bHostBtn.target = self
        bHostBtn.action = #selector(bHostAction)
        barView.addSubview(bHostBtn)
        bHostBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(bUserBtn.snp.right).offset(20)
            maker.width.greaterThanOrEqualTo(0)
            maker.centerY.equalToSuperview()
            maker.height.equalToSuperview()
        }

        bLinkBtn.fixButtonBehavior()
        customizeButton(bLinkBtn)
        bLinkBtn.target = self
        bLinkBtn.action = #selector(bLinkAction)
        barView.addSubview(bLinkBtn)
        bLinkBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(bHostBtn.snp.right).offset(20)
            maker.width.greaterThanOrEqualTo(0)
            maker.centerY.equalToSuperview()
            maker.height.equalToSuperview()
        }

        backButton.image = NSImage(named: NSImage.Name("BackDone"))
        backButton.alternateImage = NSImage(named: NSImage.Name("BackDoneOn"))
        backButton.fixButtonBehavior()
        backButton.target = self
        backButton.action = #selector(backButtonAction)
        barView.addSubview(backButton)
        backButton.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(-20)
            maker.width.greaterThanOrEqualTo(0)
            maker.centerY.equalToSuperview()
            maker.height.greaterThanOrEqualTo(0)
        }

        indicatorLine.wantsLayer = true
        indicatorLine.layer?.backgroundColor = NSColor.white.cgColor
        indicatorLine.layer?.cornerRadius = 1
        barView.addSubview(indicatorLine)
        indicatorLine.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(accountBtn)
            maker.width.equalTo(accountBtn)
            maker.bottom.equalToSuperview()
            maker.height.equalTo(2)
        }
    }

    func relayoutIndictorLine(to button: NSButton) {
        indicatorLine.snp.remakeConstraints { (maker) in
            maker.centerX.equalTo(button)
            maker.width.equalTo(button)
            maker.bottom.equalToSuperview()
            maker.height.equalTo(2)
        }
    }
}
