//
//  ArticleCellView+Subviews.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/11/1.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension ArticleCellView {
    func setupSubviews() {
        pTitleField.textColor = .white
        pTitleField.cell?.wraps = true
        pTitleField.cell?.truncatesLastVisibleLine = true
        pTitleField.maximumNumberOfLines = 2
        pTitleField.font = NSFont.boldSystemFont(ofSize: 14)
        pTitleField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(pTitleField)
        pTitleField.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(20)
            maker.right.equalToSuperview().offset(-20)
            maker.top.equalToSuperview().offset(20)
            maker.height.greaterThanOrEqualTo(0)
        }

        pSummaryLabel.textColor = NSColor.lightGray
        pSummaryLabel.cell?.wraps = true
        pSummaryLabel.cell?.truncatesLastVisibleLine = true
        pSummaryLabel.maximumNumberOfLines = 3
        pSummaryLabel.font = NSFont.systemFont(ofSize: 12)
        pSummaryLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(pSummaryLabel)
        pSummaryLabel.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(20)
            maker.right.equalToSuperview().offset(-20)
            maker.top.equalTo(pTitleField.snp.bottom).offset(5)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalToSuperview().offset(-20) //对TableCellView自适应十分重要
        }
    }
}
