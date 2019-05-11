//
//  AppDelegate.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/6/4.
//  Copyright © 2018年 Moonlight. All rights reserved.
//

import Cocoa
import SnapKit


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate,NSToolbarDelegate,NSWindowDelegate {

    let pNotiObserverManager = FMNotificationManager()

    @IBOutlet weak var window: NSWindow!
    let titlebar = TitleBarView()

    var ctrllers = [NSViewController & AppDelegateCtrllerPresentingProtocol]()

    
    //防止重复误击设置按钮的时间戳
    var pLastDate = Date()
    
    var accountCtrller: AccountCtrller?
    let pWarningCtrller = WarningCtrller.init(nibName: nil, bundle: nil)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        window.styleMask = [.closable,.miniaturizable,.titled,.fullSizeContentView,.resizable]
        window.isMovableByWindowBackground = true
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.delegate = self
        window.minSize = CGSize(width: 700, height: 550)

        window.backgroundColor = NSColor.clear
        window.contentView?.wantsLayer = true
        window.contentView?.layer?.backgroundColor = gDarkColor.cgColor
        window.contentView?.layer?.cornerRadius = 5.0
        window.contentView?.layer?.masksToBounds = true
        
        //定制titlebar
        customizeTitleBar()
        customizeTrafficLights()

        //warning view
        pWarningCtrller.pContainerView = window.contentView

        //显示登陆界面
        presentViewCtrller(AccountCtrller(nibName: nil, bundle: nil))

        monitorNotifications()
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if let window = sender.windows.first {
            if flag {
                window.orderFront(nil)
            } else {
                window.makeKeyAndOrderFront(nil)
            }
        }
        
        return true
    }


    func monitorNotifications() {

    }
}
