//
//  PubTopicItemCtrller+Menu.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/1/3.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension PubTopicItemCtrller {
    func setupMenu() {
        let subscribeItem = NSMenuItem(title: "关注该主题", action: #selector(subscribeTopic), keyEquivalent: "s")
        let seperator1 = NSMenuItem.separator()
        let editItem = NSMenuItem(title: "编辑该主题", action: #selector(presentTopicEditView), keyEquivalent: "e")
        let seperator2 = NSMenuItem.separator()
        let blockItem = NSMenuItem(title: "屏蔽该主题", action: #selector(blockTopic), keyEquivalent: "b")
        //        let deleteItem = NSMenuItem(title: "删除主题", action: #selector(deleteAction), keyEquivalent: "d")
        pMenu.addItem(subscribeItem)
        pMenu.addItem(seperator1)
        pMenu.addItem(editItem)
        pMenu.addItem(seperator2)
        pMenu.addItem(blockItem)
        //        pMenu.addItem(deleteItem)
        pMenu.delegate = self
        effectView.rightClickMenu = pMenu
    }

    @objc func subscribeTopic() {
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

        var url = gServerBaseURL.appendingPathComponent("api/topics/subscribe")
        url.appendPathComponent(String(localUserID))
        url.appendPathComponent(String(topicID))

        //Auth
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")

        //Task
        markProcessing()
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
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
                NotificationCenter.default.post(name: .SubscribeNotification, object: self.topic)
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

    @objc func blockTopic() {
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

        var url = gServerBaseURL.appendingPathComponent("api/topics/block")
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
                NotificationCenter.default.post(name: .BlockTopicNotifcation, object: self.topic)
            default:
                if let data = data,let json = try? JSONSerialization.jsonObject(with: data),let jsonD = json as? Dictionary<String,Any>,let reason = jsonD["reason"] as? String {
                    GPresentWarning(reason)
                }
                else{
                    GPresentWarning("屏蔽主题接口中无法识别的错误")
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

    @objc func deleteAction() {
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
        guard let creatorID = topic?.creatorID, creatorID == localUserID else {
            GPresentWarning("只有主题创建者能删除该主题")
            return
        }

        var url = gServerBaseURL.appendingPathComponent("api/topics/delete")
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
            print(response.statusCode)
            switch response.statusCode {
            case 200:
                NotificationCenter.default.post(name: .DeleteTopicNotification, object: self.topic)
            default:
                if let data = data,let json = try? JSONSerialization.jsonObject(with: data),let jsonD = json as? Dictionary<String,Any>,let reason = jsonD["reason"] as? String {
                    GPresentWarning(reason)
                }
                else{
                    GPresentWarning("删除主题接口中无法识别的错误")
                }
            }
        }
        task.resume()
    }
}


extension PubTopicItemCtrller: NSMenuDelegate,NSMenuItemValidation {
    func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        if menuItem.keyEquivalent == "e" {
            return gUser?.id == topic?.creatorID
        }
        else {
            return true
        }
    }
}

extension Notification.Name {
    static let SubscribeNotification = Notification.Name("SubscribeNotification")
    static let BlockTopicNotifcation = Notification.Name("BlockTopicNotifcation")
}
