//
//  BrowserCtrller+Actions.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/3/21.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension BrowserCtrller {
    @objc func blockUser() {
        guard let localUserID = gUser?.id else {
            GPresentWarning("没有有效的本地用户")
            return
        }
        guard let bUserID = pLink?.posterID else {
            GPresentWarning("无效的发布人ID")
            return
        }

        //防止重复操作
        if let _ = pSplitCtrller?.blockingUserIDs.first(where:{return $0.id == bUserID}) {
            return
        }

        let closure = (bUserID,1)
        pSplitCtrller?.blockingUserIDs.append(closure)
        NotificationCenter.default.post(name: .BUserNotification, object: closure)
        let pair = Blocks.init(ownerID: localUserID, blockedUserID: bUserID, blockedHost: nil, blockedLink: nil, isOffensive: false)
        summitBlock(with: pair)
    }

    @objc func blockHost() {
        guard let localUserID = gUser?.id else {
            GPresentWarning("没有有效的本地用户")
            return
        }
        guard let bHost = pLink?.host else {
            GPresentWarning("无效的网址host")
            return
        }

        //防止重复操作
        if let _ = pSplitCtrller?.blockingHosts.first(where:{return $0.host == bHost}) {
            return
        }

        let closure = (bHost,1)
        pSplitCtrller?.blockingHosts.append(closure)
        NotificationCenter.default.post(name: .BHostNotification, object: closure)
        let pair = Blocks.init(ownerID: localUserID, blockedUserID: nil, blockedHost: bHost, blockedLink: nil, isOffensive: false)
        summitBlock(with: pair)
    }

    @objc func blockLink() {
        guard let localUserID = gUser?.id else {
            GPresentWarning("没有有效的本地用户")
            return
        }
        guard let bLink = pLink?.link else {
            GPresentWarning("无效的网址")
            return
        }

        //防止重复操作
        if let _ = pSplitCtrller?.blockingLinks.first(where:{return $0.link == bLink}) {
            return
        }

        let closure = (bLink,1,false)
        pSplitCtrller?.blockingLinks.append(closure)
        NotificationCenter.default.post(name: .BLinkNotification, object: closure)
        let pair = Blocks.init(ownerID: localUserID, blockedUserID: nil, blockedHost: nil, blockedLink: bLink, isOffensive: false)
        summitBlock(with: pair)
    }

    @objc func illegalReport() {
        guard let localUserID = gUser?.id else {
            GPresentWarning("没有有效的本地用户")
            return
        }
        guard let bLink = pLink?.link else {
            GPresentWarning("无效的网址")
            return
        }

        //防止重复操作
        if let _ = pSplitCtrller?.blockingLinks.first(where:{return $0.link == bLink}) {
            return
        }

        //报告非法会同时屏蔽该链接
        let closure = (bLink,1,true)
        pSplitCtrller?.blockingLinks.append(closure)
        NotificationCenter.default.post(name: .BLinkNotification, object: closure)
        let pair = Blocks.init(ownerID: localUserID, blockedUserID: nil, blockedHost: nil, blockedLink: bLink, isOffensive: true)
        summitBlock(with: pair)
    }
    
    @objc func openInSafari() {
        guard let addr = pLink?.link else {return}
        guard let url = URL.init(string: addr) else {return}
        NSWorkspace.shared.open(url)
    }

    func summitBlock(with pair: Blocks) {
        //前置检测
        guard let auth = gAuth else {
            GPresentWarning("没有有效的用户认证")
            return
        }

        guard let uploadData = try? JSONEncoder().encode(pair) else {
            debugPrint("uploadData is nil")
            return
        }

        //组装URL
        let url = gServerBaseURL.appendingPathComponent("api/replies/blocks")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = uploadData
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            func statusHandler(_ status: Int) {
                //从正在操作的记录中移除
                if let buserID = pair.blockedUserID,let index = self.pSplitCtrller?.blockingUserIDs.firstIndex(where:{return $0.id == buserID}) {
                    var closure = self.pSplitCtrller!.blockingUserIDs[index]
                    closure.status = status
                    self.pSplitCtrller!.blockingUserIDs[index] = closure
                    NotificationCenter.default.post(name: .BUserNotification, object: closure)
                }
                else if let bhost = pair.blockedHost,let index = self.pSplitCtrller?.blockingHosts.firstIndex(where:{return $0.host == bhost}) {
                    var closure = self.pSplitCtrller!.blockingHosts[index]
                    closure.status = status
                    self.pSplitCtrller!.blockingHosts[index] = closure
                    NotificationCenter.default.post(name: .BHostNotification, object: closure)
                }
                else if let blink = pair.blockedLink,let index = self.pSplitCtrller?.blockingLinks.firstIndex(where:{return $0.link == blink}) {
                    var closure = self.pSplitCtrller!.blockingLinks[index]
                    closure.status = status
                    self.pSplitCtrller!.blockingLinks[index] = closure
                    NotificationCenter.default.post(name: .BLinkNotification, object: closure)
                }
            }
            
            if let errorT = error {
                GPresentWarning("错误: \(errorT.localizedDescription)")
                statusHandler(0)
                return
            }

            guard let response = response as? HTTPURLResponse else {
                GPresentWarning("服务器返回无效的响应，请稍后再试。")
                statusHandler(0)
                return
            }

            switch response.statusCode {
            case 201:
                statusHandler(2)
            default:
                statusHandler(0)
                if let data = data,let json = try? JSONSerialization.jsonObject(with: data), let jsonD = json as? Dictionary<String,Any>,let reason = jsonD["reason"] as? String {
                    GPresentWarning(reason)
                }
                else{
                    GPresentWarning("过滤接口中无法识别的错误")
                }
            }
        }
        task.resume()
    }
}

extension Notification.Name {
    static let BUserNotification = Notification.Name("BUserNotification")
    static let BHostNotification = Notification.Name("BHostNotification")
    static let BLinkNotification = Notification.Name("BLinkNotification")
}
