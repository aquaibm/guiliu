//
//  TopicItemCtrller+SelectionHighlight.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/10/30.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension PubTopicItemCtrller {
    override var isSelected: Bool {
        didSet {
            OperationQueue.main.addOperation {
                self.pHighlightView.isHidden = !(self.isSelected)
            }
        }
    }
}
