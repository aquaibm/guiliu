//
//  AppDelegate+CtrllerPresenting.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/3/4.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension AppDelegate {
    func presentViewCtrller(_ ctrller: NSViewController&AppDelegateCtrllerPresentingProtocol) {
        //如果ctrlllers数组非空，则有必要隐藏最后一个ctrller的view
        if let last = self.ctrllers.last {
            last.view.isHidden = true
        }

        self.ctrllers.append(ctrller)
        self.titlebar.functionView = ctrller.barView
        self.window.contentView?.addSubview(ctrller.view)
        ctrller.view.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalToSuperview()
            maker.top.equalTo(self.titlebar.snp.bottom)
        }
    }

    func dismissCurrentCtrller() {
        guard ctrllers.count > 0 else { return }

        let current = self.ctrllers.removeLast()
        current.view.removeFromSuperview()

        //尝试恢复上一个ctrller的view
        guard let last = self.ctrllers.last else {return}
        last.view.isHidden = false
        titlebar.functionView = last.barView
    }

    func dismissAllCtrllers() {
        for _ in 0..<ctrllers.count {
            dismissCurrentCtrller()
        }
    }
}
