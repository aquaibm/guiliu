//
//  CMUnselectCursorField.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/12/31.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit

class CMUnselectCursorField: CMCursorField {

    override func textDidEndEditing(_ notification: Notification) {
        super.textDidEndEditing(notification)

        if let textEditor = self.currentEditor() {
            textEditor.selectedRange = NSRange(location: textEditor.selectedRange.length, length: 0)
        }
    }
}
