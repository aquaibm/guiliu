//
//  BrowserCtrller+OperationStatus.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/3/23.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension BrowserCtrller {

    func monitorNotifications() {
        pNotiObserverManager.addObserver(notificationNames: [.BUserNotification,.BHostNotification,.BLinkNotification], fromObject: nil, queue: OperationQueue.main) {[unowned self] (noti) in
            self.updateOperationStatus()
        }
    }
    
    func updateOperationStatus() {
        if let userID = pLink?.posterID,let closure = pSplitCtrller?.blockingUserIDs.first(where:{return $0.id == userID}) {
            if closure.status == 0 {
                buserSpin.stopAnimation(nil)
                buserBtn.isEnabled = true
            }
            else if closure.status == 1 {
                buserSpin.startAnimation(nil)
                buserBtn.isEnabled = false
            }
            else {
                buserSpin.stopAnimation(nil)
                buserBtn.isEnabled = false
            }
        }
        else {
            buserSpin.stopAnimation(nil)
            buserBtn.isEnabled = true
        }

        if let bhost = pLink?.host,let closure = pSplitCtrller?.blockingHosts.first(where:{return $0.host == bhost}) {
            if closure.status == 0 {
                bhostSpin.stopAnimation(nil)
                bhostBtn.isEnabled = true
            }
            else if closure.status == 1 {
                bhostSpin.startAnimation(nil)
                bhostBtn.isEnabled = false
            }
            else {
                bhostSpin.stopAnimation(nil)
                bhostBtn.isEnabled = false
            }
        }
        else {
            bhostSpin.stopAnimation(nil)
            bhostBtn.isEnabled = true
        }

        if let blink = pLink?.link,let closure = pSplitCtrller?.blockingLinks.first(where:{return $0.link == blink}) {
            if closure.status == 0 {
                blinkSpin.stopAnimation(nil)
                blinkBtn.isEnabled = true
                illegalSpin.stopAnimation(nil)
                illegalBtn.isEnabled = true
            }
            else if closure.status == 1 {
                blinkSpin.startAnimation(nil)
                blinkBtn.isEnabled = false
                illegalSpin.startAnimation(nil)
                illegalBtn.isEnabled = false
            }
            else {
                blinkSpin.stopAnimation(nil)
                blinkBtn.isEnabled = false
                illegalSpin.stopAnimation(nil)
                illegalBtn.isEnabled = false
            }
        }
        else {
            blinkSpin.stopAnimation(nil)
            blinkBtn.isEnabled = true
            illegalSpin.stopAnimation(nil)
            illegalBtn.isEnabled = true
        }
    }
}
