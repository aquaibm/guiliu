//
//  LabelCustomizeProtocol.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/12/16.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit


protocol TextFieldCustomizeProtocol {

}


extension TextFieldCustomizeProtocol {
    func customizeTransparentLabel(_ label: NSTextField, placeholderString: String? = nil ,aligment: NSTextAlignment = .left, fontSize: CGFloat = 15) {
        label.isBezeled = false
        label.drawsBackground = false
        label.textColor = .white
        label.focusRingType = .none
        label.usesSingleLineMode = true
        label.font = NSFont.systemFont(ofSize: fontSize)

        guard let holder = placeholderString else {
            return
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = aligment

        let dict = [NSAttributedString.Key.foregroundColor: NSColor.gray,NSAttributedString.Key.font: NSFont.systemFont(ofSize: fontSize),NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let att = NSAttributedString(string: holder, attributes: dict)
        label.placeholderAttributedString = att
    }
}
