//
//  EditTopicCtrller+TrackArea.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/2/9.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension TopicEditCtrller {
    override func viewDidLayout() {
        super.viewDidLayout()

        if let area = self.trackArea {
            view.removeTrackingArea(area)
        }

        let previewView = effectView.superview!
        trackArea = NSTrackingArea(rect: previewView.frame, options: [.activeAlways,.mouseEnteredAndExited], owner: self, userInfo: nil)
        anchorView.addTrackingArea(trackArea!)
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
