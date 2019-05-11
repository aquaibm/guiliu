//
//  SettingsCtrller.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/10/26.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit


class SettingsCtrller: NSViewController,AppDelegateCtrllerPresentingProtocol {

    let barView = NSView()
    let accountBtn = NSButton(title: "账户管理", target: nil, action: nil)
    let bTopicBtn = NSButton(title: "屏蔽的主题", target: nil, action: nil)
    let bUserBtn = NSButton(title: "屏蔽的用户", target: nil, action: nil)
    let bHostBtn = NSButton(title: "屏蔽的整站", target: nil, action: nil)
    let bLinkBtn = NSButton(title: "屏蔽的单页", target: nil, action: nil)
    let backButton = NSButton()
    let indicatorLine = NSView()

    var selectedCtr: NSViewController?
    var accountCtr: AccountManagerCtrller?
    var topicCtr: BTopicCtrller?
    var userCtr: BUserCtrller?
    var hostCtr: BHostCtrller?
    var linkCtr: BLinkCtrller?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBarView()

        //默认选中账号管理页面
        accountAction()
    }
}
