//
//  PostArticleCtrller+SubViews.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/11/24.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension LinkPostCtrller: TextFieldCustomizeProtocol {
    func setupSubViews() {
        customizeTransparentLabel(addressInputField, placeholderString: "在此粘贴或输入网址")
        view.addSubview(addressInputField)
        addressInputField.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(80)
            maker.left.equalToSuperview().offset(150)
            maker.right.equalToSuperview().offset(-150)
            maker.height.greaterThanOrEqualTo(0)
        }

        let lineView = NSView()
        lineView.wantsLayer = true
        lineView.layer?.backgroundColor = NSColor.lightGray.cgColor
        lineView.layer?.cornerRadius = 1.0
        view.addSubview(lineView, positioned: .below, relativeTo: addressInputField)
        lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(addressInputField)
            maker.right.equalTo(addressInputField)
            maker.height.equalTo(2)
            maker.bottom.equalTo(addressInputField).offset(10)
        }

        spinIndicator.controlSize = .regular
        spinIndicator.style = .spinning
        spinIndicator.set(tintColor: NSColor.white)
        spinIndicator.isDisplayedWhenStopped = false
        view.addSubview(spinIndicator)
        spinIndicator.snp.makeConstraints { (maker) in
            maker.left.equalTo(lineView)
            maker.top.equalTo(lineView.snp.bottom).offset(30)
            maker.width.height.greaterThanOrEqualTo(0)
        }

        tipLabel.textColor = NSColor.gray
        tipLabel.font = NSFont.systemFont(ofSize: 15)
        view.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(lineView)
            maker.right.equalTo(lineView)
            maker.centerY.equalTo(spinIndicator)
            maker.height.greaterThanOrEqualTo(0)
        }

        hostLabel.textColor = NSColor.gray
        hostLabel.font = NSFont.systemFont(ofSize: 15)
        view.addSubview(hostLabel)
        hostLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(lineView)
            maker.right.equalTo(lineView)
            maker.top.equalTo(spinIndicator.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }

        titleLabel.textColor = NSColor.white
        titleLabel.cell?.wraps = true
        titleLabel.cell?.truncatesLastVisibleLine = true
        titleLabel.maximumNumberOfLines = 2
        titleLabel.font = NSFont.boldSystemFont(ofSize: 15)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(lineView)
            maker.width.equalTo(300)
            maker.top.equalTo(hostLabel.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }

        summaryLabel.textColor = NSColor.lightGray
        summaryLabel.cell?.wraps = true
        summaryLabel.cell?.truncatesLastVisibleLine = true
        summaryLabel.maximumNumberOfLines = 4
        summaryLabel.font = NSFont.systemFont(ofSize: 15)
        view.addSubview(summaryLabel)
        summaryLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(lineView)
            maker.width.equalTo(titleLabel)
            maker.top.equalTo(titleLabel.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }
    }
}
