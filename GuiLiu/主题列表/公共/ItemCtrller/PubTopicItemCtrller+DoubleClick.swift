//
//  TopicItemCtrller+DoubleClick.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/10/30.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension PubTopicItemCtrller {
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)

        if event.clickCount == 2,effectView.rightClickMenu != nil {
            doubleClickAction()
        }
    }

    func doubleClickAction() {
        guard let tp = topic else {
            return
        }

        OperationQueue.main.addOperation {
            let ctrller = LinksSplitCtrller.init(nibName: nil, bundle: nil)
            gAppDelegate.presentViewCtrller(ctrller)
            ctrller.updateWithTopic(tp)
        }
    }
}
