//
//  PostArticleCtrller.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/11/5.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit

class LinkPostCtrller: NSViewController,AppDelegateCtrllerPresentingProtocol {
    fileprivate let pNotiObserverManager = FMNotificationManager()

    var pTopic: Topic?

    let barView = NSView()
    let submitButton = NSButton()
    let postSpin = NSProgressIndicator()
    var pTask: URLSessionDataTask?
    
    let addressInputField = CMNotifyInputField(string: "")
    let spinIndicator = NSProgressIndicator()
    let tipLabel = NSTextField(labelWithString: "")
    let hostLabel = NSTextField(labelWithString: "")
    let titleLabel = NSTextField(labelWithString: "")
    let summaryLabel = NSTextField(labelWithString: "")

    var pCurrentURL: URL? //预览中的url
    var pURLHistories = [String]() //粘贴板读取自动填充记录
    var pDateMark = Date() //标记最新预览的时间，牵涉到异步

    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = gDarkColor.cgColor

        //添加一个不可见的全覆盖button，不让其误操作被覆盖区的功能
        let invisibleButton = NSButton()
        invisibleButton.isTransparent = true
        view.addSubview(invisibleButton)
        invisibleButton.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }

        setupBarView()
        setupSubViews()
        listenToNotifications()
    }

    func listenToNotifications() {
        pNotiObserverManager.addObserver(notificationName: .InputFieldDidActive, fromObject: addressInputField, queue: OperationQueue.main) {[unowned self] (noti) in
            self.getURLFromPasteboard()
        }

        pNotiObserverManager.addObserver(notificationName: NSWindow.didResignKeyNotification, fromObject: gAppDelegate.window, queue: OperationQueue.main) { (noti) in
            gAppDelegate.window.makeFirstResponder(nil)
        }

        pNotiObserverManager.addObserver(notificationName: NSControl.textDidChangeNotification, fromObject: addressInputField, queue: OperationQueue.main) {[unowned self] (noti) in
            self.loadPreviewData()
        }
    }
}
