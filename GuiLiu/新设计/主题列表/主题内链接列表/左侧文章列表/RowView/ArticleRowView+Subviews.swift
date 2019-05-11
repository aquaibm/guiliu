//
//  ArticleRowView+Subviews.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/12/2.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension ArticleRowView {
    func setupSubviews() {
        pHighlightView.wantsLayer = true
        pHighlightView.isHidden = true
        pHighlightView.layer?.backgroundColor = ColorFromRGB(rgbValue: 0xEFA955).cgColor
        addSubview(pHighlightView)
        pHighlightView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(10)
            maker.width.equalTo(6)
            maker.top.equalToSuperview().offset(20)
            maker.bottom.equalToSuperview().offset(-20)
        }
    }
}
