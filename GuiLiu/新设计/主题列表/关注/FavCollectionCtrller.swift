//
//  FavoriteCtrller.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/10/26.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit


class FavCollectionCtrller: NSViewController,TopicsFetchProtocol,TextFieldCustomizeProtocol,ViewDecorateProtocol,CMSearchDelegate {

    let pNotiObserverManager = FMNotificationManager()

    let searchView = CMSearchView()

    let leftButton = NSButton()
    var leftTArea: NSTrackingArea?
    let rightButton = NSButton()
    var rightTArea: NSTrackingArea?
    let tipLabel = NSTextField(labelWithString: "")

    @IBOutlet weak var pScrollView: NSScrollView!
    @IBOutlet weak var pCollectionView: NSCollectionView!

    let topicsURLComponentKey = "api/topics/subscribedtopics"
    let topicPagesCountURLComponentKey = "api/topics/subscribedtotalpages"

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
        pCollectionView.register(FavTopicItemCtrller.self, forItemWithIdentifier: .FavTopicItemIdentifier)
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
            self.didUnsubscribeTopic(noti)
        }

        pNotiObserverManager.addObserver(notificationName: .SubscribeNotification, fromObject: nil, queue: OperationQueue.main) { [unowned self] (noti) in
            self.handleSubscribeTopic(noti)
        }

        pNotiObserverManager.addObserver(notificationName: .BackFromTopicEdit, fromObject: nil, queue: OperationQueue.main) { [unowned self] (noti) in
            self.didEditTopic(noti)
        }


        pNotiObserverManager.addObserver(notificationName: .BackFromTopicCreate, fromObject: nil, queue: OperationQueue.main) { [unowned self] (noti) in
            self.didBackFromTopicCreate(noti)
        }

        //响应删除已屏蔽的主题
        pNotiObserverManager.addObserver(notificationName: .BTopicDeletedNoti, fromObject: nil, queue: OperationQueue.main) { [unowned self] (noti) in
            self.fetchTopicsOf(self.batchNumber)
        }
    }
}


extension NSUserInterfaceItemIdentifier {
    static let FavTopicItemIdentifier = NSUserInterfaceItemIdentifier("FavTopicItemIdentifier")
}
