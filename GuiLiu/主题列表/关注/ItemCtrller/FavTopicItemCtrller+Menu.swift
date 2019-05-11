//
//  FavTopicItemCtrller+Menu.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/1/3.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension FavTopicItemCtrller {
    func setupMenu() {
        let subscribeItem = NSMenuItem(title: "取消关注", action: #selector(unsubscribeTopic), keyEquivalent: "u")
        let seperator = NSMenuItem.separator()
        let editItem = NSMenuItem(title: "编辑该主题", action: #selector(presentTopicEditView), keyEquivalent: "e")

        pMenu.addItem(subscribeItem)
        pMenu.addItem(seperator)
        pMenu.addItem(editItem)

        pMenu.delegate = self
        
        effectView.rightClickMenu = pMenu
    }


    @objc func unsubscribeTopic() {
        //前置检测
        guard let localUserID = gUser?.id else {
            GPresentWarning("没有有效的本地用户存在")
            return
        }
        guard let auth = gAuth else {
            GPresentWarning("没有有效的用户认证")
            return
        }
        guard let topicID = topic?.id else {
            GPresentWarning("主题ID无效")
            return
        }

        var url = gServerBaseURL.appendingPathComponent("api/topics/unsubscribe")
        url.appendPathComponent(String(localUserID))
        url.appendPathComponent(String(topicID))

        //Auth
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")

        //Task
        markProcessing()
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //恢复菜单
            self.markProcessCompleted()
            //错误处理
            if let errorT = error {
                GPresentWarning("错误: \(errorT.localizedDescription)")
                return
            }
            guard let response = response as? HTTPURLResponse else {
                GPresentWarning("服务器返回无效的响应，请稍后再试。")
                return
            }

            //结果处理
            switch response.statusCode {
            case 200:
                NotificationCenter.default.post(name: .UnsubscribeNotification, object: self.topic)
            default:
                if let data = data,let json = try? JSONSerialization.jsonObject(with: data),let jsonD = json as? Dictionary<String,Any>,let reason = jsonD["reason"] as? String {
                    GPresentWarning(reason)
                }
                else{
                    GPresentWarning("取消订阅主题接口中无法识别的错误")
                }
            }
        }
        task.resume()
    }

    @objc func presentTopicEditView() {
        let ctrller = TopicEditCtrller.init(nibName: nil, bundle: nil)
        gAppDelegate.presentViewCtrller(ctrller)
        ctrller.updateInfo(with: topic!)
    }
}


extension FavTopicItemCtrller: NSMenuDelegate,NSMenuItemValidation {
    func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        if menuItem.keyEquivalent == "e" {
            return gUser?.id == topic?.creatorID
        }
        else if menuItem.keyEquivalent == "d" {
            return gUser?.id == topic?.creatorID
        }
        else {
            return true
        }
    }
}


extension Notification.Name {
    static let UnsubscribeNotification = Notification.Name("UnsubscribeNotification")
    static let DeleteTopicNotification = Notification.Name(rawValue: "deleteTopicNotification")
}
