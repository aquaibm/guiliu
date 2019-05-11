//
//  TopicsCtrller.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/3/5.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

class TopicsContainerCtrller: NSViewController,AppDelegateCtrllerPresentingProtocol {
    let pNotiObserverManager = FMNotificationManager()
    
    let barView = NSView()
    let publicButton = NSButton(title: "公共", target: nil, action: nil)
    let favoriteButton = NSButton(title: "关注", target: nil, action: nil)
    let settingsButton = NSButton(title: "设置", target: nil, action: nil)
    let indicatorLine = NSView()

    enum TabType {
        case `public`
        case favorite
    }
    var selectedTab: TabType?
    var selectedCtr: NSViewController?
    var publicCtr: PubCollectionCtrller?
    var favoriteCtr: FavCollectionCtrller?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBarView()
        presentPubCtrller()
        monitorNotifications()
    }

    func monitorNotifications() {
        pNotiObserverManager.addObserver(notificationName: .BackFromTopicCreate, fromObject: nil, queue: OperationQueue.main) { [unowned self] (noti) in
            self.didBackFromTopicCreate(noti)
        }
    }
}
