//
//  AccountCtrller.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/6/7.
//  Copyright © 2018年 Moonlight. All rights reserved.
//

import Foundation
import AppKit
import SnapKit

class AccountCtrller: NSViewController, AppDelegateCtrllerPresentingProtocol {
    let barView = NSView()

    let directlyView = NSView()
    let newcomerView = NSView()
    var accountInfo: (String?,String?,String?) = (nil,nil,nil)

    let pSpin = NSProgressIndicator()
    let policyBtn = NSButton()
    var trackArea: NSTrackingArea!
    var topButton = NSButton(radioButtonWithTitle: "", target: nil, action: nil)
    var botButton = NSButton(radioButtonWithTitle: "", target: nil, action: nil)

    var pAutoLogin = true
    enum MethodType {
        case login
        case register
        case none
    }
    var methodType = MethodType.none
    
    struct ViewMetrics {
        static let width = 150 //中下部view宽度限制
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewForNewcomer()
        setupViewForLoginDirectly()
        setupBottomView()

        //默认暂时直接登录页面
        presentDirectlyView()

        //如果keychain有数据，自动填写并登陆
        if let info = getKeychainInfo(), pAutoLogin == true {
            let nameLabel = directlyView.viewWithTag(1001) as? NSTextField
            let pwLabel = directlyView.viewWithTag(1002) as? NSSecureTextField
            nameLabel?.stringValue = info.0
            pwLabel?.stringValue = info.1
            loginDirectly()
        }
    }
}
