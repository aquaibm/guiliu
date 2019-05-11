//
//  PostArticleCtrller+BarView.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/11/5.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension LinkPostCtrller {
    func setupBarView(){
        submitButton.image = NSImage(named: NSImage.Name("submit"))
        submitButton.alternateImage = NSImage(named: NSImage.Name("submitOn"))
        submitButton.fixButtonBehavior()
        submitButton.target = self
        submitButton.action = #selector(submitAction) 
        submitButton.isEnabled = false
        barView.addSubview(submitButton)
        submitButton.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(-20)
            maker.width.greaterThanOrEqualTo(0)
            maker.centerY.equalToSuperview()
            maker.height.greaterThanOrEqualTo(0)
        }

        let cancleButton = NSButton()
        cancleButton.image = NSImage(named: NSImage.Name("CanclePost"))
        cancleButton.alternateImage = NSImage(named: NSImage.Name("CanclePostOn"))
        cancleButton.fixButtonBehavior()
        cancleButton.target = self
        cancleButton.action = #selector(cancleAction)
        barView.addSubview(cancleButton)
        cancleButton.snp.makeConstraints { (maker) in
            maker.right.equalTo(submitButton.snp.left).offset(-20)
            maker.width.greaterThanOrEqualTo(0)
            maker.centerY.equalToSuperview()
            maker.height.greaterThanOrEqualTo(0)
        }

        postSpin.controlSize = .small
        postSpin.style = .spinning
        postSpin.set(tintColor: NSColor.white)
        postSpin.isDisplayedWhenStopped = false
        barView.addSubview(postSpin)
        postSpin.snp.makeConstraints { (maker) in
            maker.right.equalTo(cancleButton.snp.left).offset(-20)
            maker.width.greaterThanOrEqualTo(0)
            maker.centerY.equalToSuperview()
            maker.height.greaterThanOrEqualTo(0)
        }
    }
}
