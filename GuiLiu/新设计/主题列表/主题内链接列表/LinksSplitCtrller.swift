//
//  ArticlesPublicCtrller.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/10/30.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit


class LinksSplitCtrller: NSSplitViewController,AppDelegateCtrllerPresentingProtocol {
    fileprivate let pNotiObserverManager = FMNotificationManager()

    var topic: Topic?
    let pListsCtrller = LinkListsCtrller(nibName: nil, bundle: nil)
    let pBrowserCtrller = BrowserCtrller(nibName: nil, bundle: nil)

    //记录正在屏蔽中的对象,0为默认未处理状态，1为处理中，2为处理完
    var blockingUserIDs = [(id:Int,status:Int)]()
    var blockingHosts = [(host:String,status:Int)]()
    var blockingLinks = [(link:String,status:Int,illegal:Bool)]()

    let barView = NSView()

    override func viewDidLoad() {
        super.viewDidLoad()

        pListsCtrller.pSplitCtrller = self
        pBrowserCtrller.pSplitCtrller = self
        addSplitViewItem(NSSplitViewItem(contentListWithViewController: pListsCtrller))
        addSplitViewItem(NSSplitViewItem(contentListWithViewController: pBrowserCtrller))

        setupBarView()
        monitorNotifications()
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        splitView.setPosition(240, ofDividerAt: 0)
    }

    func updateWithTopic(_ tp: Topic) {
        topic = tp
        pListsCtrller.fetchArticles(of: tp)
    }

    func monitorNotifications() {
        pNotiObserverManager.addObserver(notificationName: .BackFromPostArticle, fromObject: nil, queue: OperationQueue.main) { [unowned self] (noti) in
            self.didBackFromLinkPost(noti: noti)
        }
    }
}
