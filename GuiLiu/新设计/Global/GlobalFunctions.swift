//
//  GlobalFunctions.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/11/17.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit


func GPresentWarning(_ texts: String...) {
    let str = texts.reduce("") { (x, y) -> String in
        x + y
    }
    gAppDelegate.pWarningCtrller.appendMessage(str)
}
