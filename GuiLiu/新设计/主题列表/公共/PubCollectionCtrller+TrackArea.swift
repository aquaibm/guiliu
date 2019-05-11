//
//  PubCollectionCtrller+TrackArea.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/12/21.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension PubCollectionCtrller {
    override func viewDidLayout() {
        super.viewDidLayout()

        //update left trackArea
        if let area = leftTArea {
            view.removeTrackingArea(area)
        }
        leftTArea = NSTrackingArea(rect: leftButton.superview!.frame, options: [.activeAlways,.mouseEnteredAndExited], owner: self, userInfo: nil)
        view.addTrackingArea(leftTArea!)

        //update right trackArea
        if let area = rightTArea {
            view.removeTrackingArea(area)
        }
        rightTArea = NSTrackingArea(rect: rightButton.superview!.frame, options: [.activeAlways,.mouseEnteredAndExited], owner: self, userInfo: nil)
        view.addTrackingArea(rightTArea!)
    }

    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        guard event.trackingArea == leftTArea || event.trackingArea == rightTArea else {
            return
        }

        leftButton.isHidden = false
        rightButton.isHidden = false
    }

    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        guard event.trackingArea == leftTArea || event.trackingArea == rightTArea else {
            return
        }

        leftButton.isHidden = true
        rightButton.isHidden = true
    }
}
