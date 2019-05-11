//
//  EditTopicCtrller.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/2/9.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

class TopicEditCtrller: NSViewController,AppDelegateCtrllerPresentingProtocol {

    fileprivate let pNotiObserverManager = FMNotificationManager()
    var topic: Topic?

    let barView = NSView()
    let submitButton = NSButton()
    let postSpin = NSProgressIndicator()
    var pTask: URLSessionDataTask?

    let anchorView = NSView()
    let desLabel = NSTextField(labelWithString: "")
    let titleLabel = NSTextField(labelWithString: "")
    let imageV = NSView(frame: .zero)
    let effectView = CMMenuVisualView()
    let pHighlightView = NSView()
    var trackArea: NSTrackingArea?

    let desInputLabel = CMCursorField(string: "")
    let imagePickerButton = NSButton()
    let lengthHelperLabel = NSTextField(string: "")
    var lastTitleString = "" //记录输入的最新的名称
    var lastDesString = "" //记录输入的最新的描述
    var imageURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBarView()
        setupSubViews()
        monitorNotifications()
    }

    func monitorNotifications() {
        pNotiObserverManager.addObserver(notificationName: NSControl.textDidChangeNotification, fromObject: desInputLabel, queue: OperationQueue.main) {[unowned self] (noti) in
            self.didInputDescription()
        }
    }
}
