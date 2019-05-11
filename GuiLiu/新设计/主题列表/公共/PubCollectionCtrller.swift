//
//  PublicCtrller.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/10/26.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit


class PubCollectionCtrller: NSViewController,TopicsFetchProtocol,TextFieldCustomizeProtocol,ViewDecorateProtocol,CMSearchDelegate {

    let pNotiObserverManager = FMNotificationManager()

    let searchView = CMSearchView()

    let leftButton = NSButton()
    var leftTArea: NSTrackingArea?
    let rightButton = NSButton()
    var rightTArea: NSTrackingArea?
    let tipLabel = NSTextField(labelWithString: "")

    @IBOutlet weak var pScrollView: NSScrollView!
    @IBOutlet weak var pCollectionView: NSCollectionView!

    let topicsURLComponentKey = "api/topics/othertopics"
    let topicPagesCountURLComponentKey = "api/topics/othertotalpages"

    var searchString = ""

    var lastSearchString: String?
    
    var latestStamp: Date?
    var pagesCount: Int?
    var batchNumber = 0    //记录数据获取批次
    var topicIDs = [Int]()

    var topicTasks = [URLSessionDataTask]()
    let concurrentTopicsQueue = DispatchQueue(label: "com.Moonlight.GuiLiu.topicQueue", qos: .userInitiated, attributes: .concurrent)
    var topics = [Topic]()

    let progressSpin = NSProgressIndicator()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        pCollectionView.register(PubTopicItemCtrller.self, forItemWithIdentifier: .PubTopicItemIdentifier)
        monitorNotifications()
        fetchTopicsOf(batchNumber)

        leftButton.target = self
        leftButton.action = #selector(getPreviousPage)
        rightButton.target = self
        rightButton.action = #selector(getNextPage)
    }

    deinit {
        topicTasks.forEach{
            guard $0.state == .running || $0.state == .suspended else { return }
            $0.cancel()
        }
    }

    func monitorNotifications() {
        pNotiObserverManager.addObserver(notificationName: .UnsubscribeNotification, fromObject: nil, queue: OperationQueue.main) { [unowned self] (noti) in
            self.handleUnsubscribeTopic(noti)
        }

        pNotiObserverManager.addObserver(notificationName: .SubscribeNotification, fromObject: nil, queue: OperationQueue.main) { [unowned self] (noti) in
            self.didSubscribeTopic(noti)
        }

        pNotiObserverManager.addObserver(notificationName: .BlockTopicNotifcation, fromObject: nil, queue: OperationQueue.main) { [unowned self] (noti) in
            self.didBlockTopic(noti)
        }

        pNotiObserverManager.addObserver(notificationName: .BackFromTopicEdit, fromObject: nil, queue: OperationQueue.main) { [unowned self] (noti) in
            self.didEditTopic(noti)
        }

        //响应删除已屏蔽的主题
        pNotiObserverManager.addObserver(notificationName: .BTopicDeletedNoti, fromObject: nil, queue: OperationQueue.main) { [unowned self] (noti) in
            self.fetchTopicsOf(self.batchNumber)
        }

        //响应删除主题
        pNotiObserverManager.addObserver(notificationName: .DeleteTopicNotification, fromObject: nil, queue: OperationQueue.main) { [unowned self] (noti) in
            self.didDeleteTopic(noti)
        }
    }
}

extension NSUserInterfaceItemIdentifier {
    static let PubTopicItemIdentifier = NSUserInterfaceItemIdentifier("PubTopicItemIdentifier")
}
