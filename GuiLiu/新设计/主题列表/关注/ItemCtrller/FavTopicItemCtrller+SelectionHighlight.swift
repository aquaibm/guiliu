//
//  TopicItemFavCtrller+SelectionHighlight.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/12/7.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension FavTopicItemCtrller {
    override var isSelected: Bool {
        didSet {
            OperationQueue.main.addOperation {
                self.pHighlightView.isHidden = !(self.isSelected)
            }
        }
    }
}
