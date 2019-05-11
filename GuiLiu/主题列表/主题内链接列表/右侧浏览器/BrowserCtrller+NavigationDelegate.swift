//
//  BrowserCtrller+NavigationDelegate.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/3/22.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit
import WebKit

extension BrowserCtrller: WKNavigationDelegate {
    //    webView(_:didStartProvisionalNavigation:)
    //    webView(_:didCommit:)
    //    webView(_:didFinish:)
    
    //开始
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard webView == self.pWebView else {return}

        OperationQueue.main.addOperation {
            self.spin.startAnimation(nil)
        }
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        //print(#function)
    }

    //错误
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        guard webView == self.pWebView else {return}

        OperationQueue.main.addOperation {
            self.spin.stopAnimation(nil)
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(#function)
    }

    //完成
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard webView == self.pWebView else {return}

        OperationQueue.main.addOperation {
            self.spin.stopAnimation(nil)
        }
    }

    //中断
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print(#function)
        guard webView == self.pWebView else {return}

        OperationQueue.main.addOperation {
            self.spin.stopAnimation(nil)
        }
    }
}
