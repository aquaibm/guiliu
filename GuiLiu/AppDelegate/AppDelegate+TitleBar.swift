//
//  AppDelegate+TitleBar.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/11/2.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit

let gTitleBarHeight: CGFloat = 40

extension AppDelegate {
    func customizeTrafficLights(){
        let closeButton = window.standardWindowButton(.closeButton)!
        let minButton = window.standardWindowButton(.miniaturizeButton)!
        let zoomButton = window.standardWindowButton(.zoomButton)!
        let buttons = [closeButton,minButton,zoomButton]
        var offset: CGFloat = 20.0
        buttons.forEach { button in
            button.removeFromSuperview()
            window.contentView?.addSubview(button)
            button.snp.makeConstraints({ maker in
                maker.left.equalToSuperview().offset(offset)
                maker.top.equalTo(15)
                maker.width.height.greaterThanOrEqualTo(0)
            })
            offset += 20
        }
        window.contentView?.layoutSubtreeIfNeeded()
        window.contentView?.superview?.viewDidEndLiveResize()
    }

    func windowDidExitFullScreen(_ notification: Notification) {
        customizeTrafficLights()
    }

    func customizeTitleBar() {
        titlebar.wantsLayer = true
        titlebar.layer?.backgroundColor = gDarkColor.cgColor
        titlebar.shadow = NSShadow()
        titlebar.layer?.shadowOpacity = 0.25
        titlebar.layer?.shadowRadius = 1.0
        titlebar.layer?.shadowOffset = NSZeroSize
        titlebar.layer?.shadowColor = NSColor.shadowColor.cgColor
        window.contentView?.addSubview(titlebar)
        titlebar.snp.makeConstraints { (maker) in
            maker.left.right.top.equalToSuperview()
            maker.height.equalTo(gTitleBarHeight)
        }
    }
}



class TitleBarView: NSView {
    var functionView: NSView? {
        didSet {
            OperationQueue.main.addOperation {
                oldValue?.removeFromSuperview()

                guard let newView = self.functionView else {
                    return
                }
                self.addSubview(newView)
                newView.snp.makeConstraints({ (maker) in
                    maker.left.equalToSuperview().offset(120)
                    maker.right.equalToSuperview()
                    maker.top.bottom.equalToSuperview()
                })
            }
        }
    }
}
