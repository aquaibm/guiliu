//
//  BrowserCtrller.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/11/1.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit
import WebKit


class BrowserCtrller: NSViewController {
    let pNotiObserverManager = FMNotificationManager()

    weak var pSplitCtrller: LinksSplitCtrller?

    let panelContainer = NSView()
    let buserBtn = NSButton()
    let bhostBtn = NSButton()
    let illegalBtn = NSButton()
    let blinkBtn = NSButton()


    //功能操作标志
    let buserSpin = NSProgressIndicator()
    let bhostSpin = NSProgressIndicator()
    let blinkSpin = NSProgressIndicator()
    let illegalSpin = NSProgressIndicator()

    var pLink: Reply?
    var pWebView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
    let spin = NSProgressIndicator() //网页加载标志

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        updateOperationStatus()
        //默认隐藏底部操作区域
        panelContainer.isHidden = true

        monitorNotifications()
    }

    func updateWith(article: Reply) {
        OperationQueue.main.addOperation {
            self.panelContainer.isHidden = false
            self.spin.stopAnimation(nil)
            self.pWebView.navigationDelegate = nil
            if let _ = self.pWebView.superview {
                self.pWebView.removeFromSuperview()
            }

            //加载有时候很慢，所以每次都新开一个webview
            self.pWebView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
            self.pWebView.navigationDelegate = self
            self.pWebView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 12_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0 Mobile/15E148 Safari/604.1"
            self.view.addSubview(self.pWebView, positioned: .below, relativeTo: self.panelContainer)
            self.pWebView.snp.makeConstraints { (maker) in
                maker.left.right.top.equalToSuperview()
                maker.bottom.equalToSuperview()
            }

            self.pLink = article

            let link = URL(string: article.link)
            let request = URLRequest(url: link!)
            self.pWebView.load(request)

            self.updateOperationStatus()
        }
    }
}
