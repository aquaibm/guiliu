//
//  CMMenuVisualView.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/1/3.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

class CMMenuVisualView: NSVisualEffectView {
    var rightClickMenu: NSMenu?

    override func menu(for event: NSEvent) -> NSMenu? {
        if event.type == .rightMouseDown {
            return rightClickMenu
        }
        else {
            return super.menu(for: event)
        }
    }
}
