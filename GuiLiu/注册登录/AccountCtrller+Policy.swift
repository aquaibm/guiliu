//
//  AccountCtrller+Policy.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/10/25.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit


extension AccountCtrller {
    override func viewDidLayout() {
        super.viewDidLayout()

        if let area = self.trackArea {
            view.removeTrackingArea(area)
        }

        trackArea = NSTrackingArea(rect: policyBtn.frame, options: [.activeAlways,.mouseEnteredAndExited], owner: self, userInfo: nil)
        view.addTrackingArea(trackArea)
    }

    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        guard event.trackingArea == trackArea else {
            return
        }
        policyBtn.image = NSImage(named: NSImage.Name("policyhighlight"))
    }

    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        guard event.trackingArea == trackArea else {
            return
        }
        policyBtn.image = NSImage(named: NSImage.Name("policy"))
    }

    @objc func openPolicy() {
        let url = gServerBaseURL.appendingPathComponent("policy")
        NSWorkspace.shared.open(url)
    }
}
