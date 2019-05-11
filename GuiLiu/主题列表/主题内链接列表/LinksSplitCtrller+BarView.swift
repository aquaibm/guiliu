//
//  TopicSplitCtrller+BarView.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/11/2.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit


extension LinksSplitCtrller {
    func setupBarView() {
        let doneButton = NSButton()
        doneButton.image = NSImage(named: NSImage.Name("BackDone"))
        doneButton.alternateImage = NSImage(named: NSImage.Name("BackDoneOn"))
        doneButton.fixButtonBehavior()
        doneButton.target = self
        doneButton.action = #selector(backDoneAction)
        barView.addSubview(doneButton)
        doneButton.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(-20)
            maker.width.greaterThanOrEqualTo(0)
            maker.centerY.equalToSuperview()
            maker.height.greaterThanOrEqualTo(0)
        }

        let newButton = NSButton()
        newButton.image = NSImage(named: NSImage.Name("AddArticle"))
        newButton.alternateImage = NSImage(named: NSImage.Name("AddArticleOn"))
        newButton.fixButtonBehavior()
        newButton.target = self
        newButton.action = #selector(newAction)
        barView.addSubview(newButton)
        newButton.snp.makeConstraints { (maker) in
            maker.right.equalTo(doneButton.snp.left).offset(-20)
            maker.width.greaterThanOrEqualTo(0)
            maker.centerY.equalToSuperview()
            maker.height.greaterThanOrEqualTo(0)
        }
    }

    @objc func backDoneAction() {
        gAppDelegate.dismissCurrentCtrller()
    }

    @objc func newAction() {
        let ctrller = LinkPostCtrller.init(nibName: nil, bundle: nil)
        ctrller.pTopic = topic
        gAppDelegate.presentViewCtrller(ctrller)
    }
}
