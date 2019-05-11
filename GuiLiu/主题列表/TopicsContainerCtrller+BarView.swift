//
//  TopicsContainerCtrller+BarView.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/3/5.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension TopicsContainerCtrller {
    func setupBarView() {
        let buttonWidth = 35
        func customizeButton(_ button: NSButton) {
            let dict = [NSAttributedString.Key.foregroundColor: NSColor.white]
            let attStr = NSAttributedString(string: button.title, attributes: dict)
            button.attributedTitle = attStr
        }

        publicButton.fixButtonBehavior()
        customizeButton(publicButton)
        publicButton.target = self
        publicButton.action = #selector(presentPubCtrller)
        barView.addSubview(publicButton)
        publicButton.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview()
            maker.width.equalTo(buttonWidth)
            maker.centerY.equalToSuperview()
            maker.height.equalToSuperview()
        }

        favoriteButton.fixButtonBehavior()
        customizeButton(favoriteButton)
        favoriteButton.target = self
        favoriteButton.action = #selector(presentFavCtrller)
        barView.addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints { (maker) in
            maker.left.equalTo(publicButton.snp.right).offset(20)
            maker.width.equalTo(buttonWidth)
            maker.centerY.equalToSuperview()
            maker.height.equalToSuperview()
        }

        let newButton = NSButton()
        newButton.image = NSImage(named: NSImage.Name("AddArticle"))
        newButton.alternateImage = NSImage(named: NSImage.Name("AddArticleOn"))
        newButton.toolTip = "创建新主题"
        newButton.fixButtonBehavior()
        newButton.target = self
        newButton.action = #selector(presentCreateTopicCtrller)
        barView.addSubview(newButton)
        newButton.snp.makeConstraints { (maker) in
            maker.left.equalTo(favoriteButton.snp.right).offset(20)
            maker.width.greaterThanOrEqualTo(0)
            maker.centerY.equalToSuperview()
            maker.height.greaterThanOrEqualTo(0)
        }

        settingsButton.fixButtonBehavior()
        customizeButton(settingsButton)
        settingsButton.target = self
        settingsButton.action = #selector(presentSettingsCtrller)
        barView.addSubview(settingsButton)
        settingsButton.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(-20)
            maker.width.equalTo(buttonWidth)
            maker.centerY.equalToSuperview()
            maker.height.equalToSuperview()
        }

        indicatorLine.wantsLayer = true
        indicatorLine.layer?.backgroundColor = NSColor.white.cgColor
        indicatorLine.layer?.cornerRadius = 1
        barView.addSubview(indicatorLine)
        indicatorLine.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(publicButton)
            maker.width.equalTo(publicButton)
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
