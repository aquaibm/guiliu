//
//  TopicItemCtrller+TrackArea.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/10/29.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit


extension PubTopicItemCtrller {
    override func viewDidLayout() {
        super.viewDidLayout()

        if let area = self.trackArea {
            view.removeTrackingArea(area)
        }

        trackArea = NSTrackingArea(rect: view.bounds, options: [.activeAlways,.mouseEnteredAndExited], owner: self, userInfo: nil)
        view.addTrackingArea(trackArea!)
    }

    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        guard event.trackingArea == trackArea else {
            return
        }
        effectView.isHidden = false
    }

    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        guard event.trackingArea == trackArea else {
            return
        }
        effectView.isHidden = true
    }
}
