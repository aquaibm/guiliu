//
//  TopicItemMenuProtocol.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/2/7.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

protocol TopicItemMenuProtocol: TopicItemViewLayoutProtocol {
    var pMenu: NSMenu {get}
    var spin: NSProgressIndicator {get}
}


extension TopicItemMenuProtocol where Self:NSCollectionViewItem {
    func setupProgressIndicator() {
        spin.controlSize = .small
        spin.style = .spinning
        spin.set(tintColor: NSColor.darkGray)
        spin.isDisplayedWhenStopped = false
        view.addSubview(spin)
        spin.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.width.height.greaterThanOrEqualTo(0)
        }
    }

    func markProcessing() {
        OperationQueue.main.addOperation {
            self.effectView.rightClickMenu = nil
            self.spin.startAnimation(nil)
        }
    }

    func markProcessCompleted() {
        OperationQueue.main.addOperation {
            self.effectView.rightClickMenu = self.pMenu
            self.spin.stopAnimation(nil)
        }
    }
}
