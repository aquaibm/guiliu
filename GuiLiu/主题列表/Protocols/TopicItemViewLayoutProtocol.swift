//
//  TopicViewLayoutProtocol.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/12/15.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit

protocol TopicItemViewLayoutProtocol:AnyObject {
    var desLabel: NSTextField {get}
    var titleLabel: NSTextField {get}
    var imageV: NSView {get}
    var effectView: CMMenuVisualView {get}
    var pHighlightView: NSView {get}
    var trackArea: NSTrackingArea? {get set}
}


extension TopicItemViewLayoutProtocol {
    func layoutTopicView(on vw: NSView) {
        vw.wantsLayer = true
        vw.layer?.backgroundColor = ColorFromRGB(rgbValue: 0x424242).cgColor
        vw.layer?.cornerRadius = 5.0

        vw.shadow = NSShadow()
        vw.layer?.shadowOpacity = 0.25
        vw.layer?.shadowRadius = 3.0
        vw.layer?.shadowOffset = NSZeroSize
        vw.layer?.shadowColor = NSColor.shadowColor.cgColor

        desLabel.textColor = NSColor.gray
        vw.addSubview(desLabel)
        desLabel.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(20)
            maker.width.greaterThanOrEqualTo(0)
            maker.right.lessThanOrEqualToSuperview().offset(-20)
            maker.top.equalToSuperview().offset(20)
            maker.height.greaterThanOrEqualTo(0)
        }

        titleLabel.textColor = NSColor.white
        titleLabel.font = NSFont.boldSystemFont(ofSize: 18)
        vw.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(20)
            maker.width.greaterThanOrEqualTo(0)
            maker.right.lessThanOrEqualToSuperview().offset(-20)
            maker.top.equalTo(desLabel.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }

        imageV.wantsLayer = true
        imageV.layer!.contentsGravity = CALayerContentsGravity.resizeAspectFill
        imageV.layer?.cornerRadius = vw.layer?.cornerRadius ?? 5.0
        vw.addSubview(imageV, positioned: .below, relativeTo: desLabel)
        imageV.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }

        //vibrancy effect
        effectView.material = .popover
        effectView.state = .active
        effectView.isHidden = true
        effectView.blendingMode = .withinWindow
        effectView.wantsLayer = true
        effectView.layer?.cornerRadius = vw.layer?.cornerRadius ?? 5.0
        vw.addSubview(effectView, positioned: .below, relativeTo: desLabel)
        effectView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }

        pHighlightView.wantsLayer = true
        pHighlightView.isHidden = true
        pHighlightView.layer?.backgroundColor = ColorFromRGB(rgbValue: 0xEFA955).cgColor
        pHighlightView.layer?.cornerRadius = vw.layer?.cornerRadius ?? 5.0
        pHighlightView.layer?.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner]
        vw.addSubview(pHighlightView)
        pHighlightView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview()
            maker.width.equalTo(6)
            maker.top.bottom.equalToSuperview()
        }
    }
}
