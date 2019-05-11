//
//  AccountManagerCtrller.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/1/9.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

class AccountManagerCtrller: NSViewController {
    fileprivate let pNotiObserverManager = FMNotificationManager()

    let emailLabel = NSTextField(labelWithString: "")
    let nickLabel = CMCursorField(string: "")
    let pwLabel = CMSecureCursorField(string: "")
    let npwLabel = CMSecureCursorField(string: "")
    let cnpwLabel = CMSecureCursorField(string: "")
    let saveBtn = NSButton()
    let saveSpin = NSProgressIndicator()
    let logoutBtn = NSButton()


    let lengthHelperLabel = NSTextField(string: "") //辅助计算输入字符串的长度

    //用于限制输入字符串的长度
    var lastNickName = ""
    var lastCurrentPassword = ""
    var lastNewPassword = ""
    var lastConfirmNewPassword = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        monitorNotifications()
        fillTheFormWithUserProfile()
    }

    func monitorNotifications() {
        pNotiObserverManager.addObserver(notificationName: NSControl.textDidChangeNotification, fromObject: nickLabel, queue: OperationQueue.main) {[unowned self] (noti) in
            self.didInputNickName()
        }

        pNotiObserverManager.addObserver(notificationName: NSControl.textDidChangeNotification, fromObject: pwLabel, queue: OperationQueue.main) {[unowned self] (noti) in
            self.didInputCurrentPassword()
        }

        pNotiObserverManager.addObserver(notificationName: NSControl.textDidChangeNotification, fromObject: npwLabel, queue: OperationQueue.main) {[unowned self] (noti) in
            self.didInputNewPassword()
        }

        pNotiObserverManager.addObserver(notificationName: NSControl.textDidChangeNotification, fromObject: cnpwLabel, queue: OperationQueue.main) {[unowned self] (noti) in
            self.didInputConfirmNewPassword()
        }
    }
}
