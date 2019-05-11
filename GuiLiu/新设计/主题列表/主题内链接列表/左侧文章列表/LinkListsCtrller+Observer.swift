//
//  LinkListsCtrller+Observer.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/3/24.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension LinkListsCtrller {
    func monitorNotifications() {
        pNotiObserverManager.addObserver(notificationName: .BUserNotification, fromObject: nil, queue: OperationQueue.main) { [unowned self] (noti) in
            //只处理状态为2的通知
            guard let closure = noti.object as? (Int,Int),closure.1 == 2 else {
                return
            }

            //在数组里寻找包含该用户的条目
            let selectedIndex = self.pTableView.selectedRow
            for i in 0..<self.pLinks.count {
                //是选中项的话，判断是否该移除
                if i == selectedIndex,let item = self.pLinks[i], item.posterID == closure.0 {
                    self.pToBeRemovedLinks.insert(item)
                }
                else if let item = self.pLinks[i], item.posterID == closure.0 {
                    self.pLinks.remove(at: i)
                    self.pTableView.removeRows(at: IndexSet.init(integer: i), withAnimation: .effectFade)
                }
            }
        }

        pNotiObserverManager.addObserver(notificationName: .BHostNotification, fromObject: nil, queue: OperationQueue.main) { [unowned self] (noti) in
            //只处理状态为2的通知
            guard let closure = noti.object as? (String,Int),closure.1 == 2 else {
                return
            }

            //在数组里寻找包含该用户的条目
            let selectedIndex = self.pTableView.selectedRow
            for i in 0..<self.pLinks.count {
                //是选中项的话，判断是否该移除
                if i == selectedIndex,let item = self.pLinks[i], item.host == closure.0 {
                    self.pToBeRemovedLinks.insert(item)
                }
                else if let item = self.pLinks[i], item.host == closure.0 {
                    self.pLinks.remove(at: i)
                    self.pTableView.removeRows(at: IndexSet.init(integer: i), withAnimation: .effectFade)
                }
            }
        }

        pNotiObserverManager.addObserver(notificationName: .BLinkNotification, fromObject: nil, queue: OperationQueue.main) { [unowned self] (noti) in
            //只处理状态为2的通知
            guard let closure = noti.object as? (String,Int,Bool),closure.1 == 2 else {
                return
            }

            //在数组里寻找包含该用户的条目
            let selectedIndex = self.pTableView.selectedRow
            for i in 0..<self.pLinks.count {
                //是选中项的话，判断是否该移除
                if i == selectedIndex,let item = self.pLinks[i], item.link == closure.0 {
                    self.pToBeRemovedLinks.insert(item)
                }
                else if let item = self.pLinks[i], item.link == closure.0 {
                    self.pLinks.remove(at: i)
                    self.pTableView.removeRows(at: IndexSet.init(integer: i), withAnimation: .effectFade)
                }
            }
        }
    }
}
