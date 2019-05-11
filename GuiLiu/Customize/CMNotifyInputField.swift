//
//  CMInputField.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/7/26.
//  Copyright © 2018年 Moonlight. All rights reserved.
//

import Foundation
import AppKit

class CMNotifyInputField: NSTextField {

    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        if result {
            let textView = self.currentEditor() as? NSTextView
            textView?.insertionPointColor = ColorFromRGB(rgbValue: 0xFF5600)
            NotificationCenter.default.post(name: .InputFieldDidActive, object: self)
        }
        return result
    }
}

extension Notification.Name {
    static let InputFieldDidActive = Notification.Name("InputFieldDidActive")
}
