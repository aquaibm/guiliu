//
//  BackgroundViewProtocol.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/12/16.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit

protocol ViewDecorateProtocol {

}


extension ViewDecorateProtocol {
    func attachBorderFrame(to vw: NSView) {
        guard let sView = vw.superview else {
            return
        }

        let backView = NSView()
        backView.wantsLayer = true
        backView.layer?.borderColor = NSColor.gray.cgColor
        backView.layer?.borderWidth = 1.0
        backView.layer?.cornerRadius = 3
        sView.addSubview(backView, positioned: .below, relativeTo: vw)
        backView.snp.makeConstraints { (maker) in
            maker.left.equalTo(vw).offset(-5)
            maker.right.equalTo(vw).offset(5)
            maker.top.equalTo(vw).offset(-5)
            maker.bottom.equalTo(vw).offset(5)
        }
    }

    func attachUnderline(to vw: NSView) {
        guard let sView = vw.superview else {
            return
        }

        let lineView = NSView()
        lineView.wantsLayer = true
        lineView.layer?.backgroundColor = NSColor.gray.cgColor
        lineView.layer?.cornerRadius = 0.5
        sView.addSubview(lineView, positioned: .below, relativeTo: vw)
        lineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(vw)
            maker.height.equalTo(1)
            maker.top.equalTo(vw.snp.bottom).offset(5)
        }
    }
}
