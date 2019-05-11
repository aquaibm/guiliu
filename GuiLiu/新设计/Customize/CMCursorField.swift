//
//  CMCursorField.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/9/15.
//  Copyright © 2018年 Moonlight. All rights reserved.
//

import Foundation
import AppKit

class CMCursorField: NSTextField {
    
    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        if result == true {
            let textView = self.currentEditor() as? NSTextView
            textView?.insertionPointColor = ColorFromRGB(rgbValue: 0xFF5600)
        }
        return result
    }

}
