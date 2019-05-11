//
//  PostArticleCtrller+PostLogic.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/11/28.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension LinkPostCtrller {
    @objc func submitAction() {
        func freezeInput() {
            OperationQueue.main.addOperation {
                self.submitButton.isEnabled = false
                self.addressInputField.isEditable = false
                self.postSpin.startAnimation(nil)
            }
        }

        func defreezeInput() {
            OperationQueue.main.addOperation {
                self.submitButton.isEnabled = true
                self.addressInputField.isEditable = true
                self.postSpin.stopAnimation(nil)
            }
        }

        freezeInput()

        //检测
        guard let localUserID = gUser?.id else {
            GPresentWarning("没有有效的本地用户存在")
            defreezeInput()
            return
        }
        guard let auth = gAuth else {
            GPresentWarning("没有有效的用户认证")
            defreezeInput()
            return
        }
        guard let topicID = pTopic?.id else {
            GPresentWarning("主题ID无效")
            defreezeInput()
            return
        }
        guard let link = pCurrentURL?.absoluteString,let host = pCurrentURL?.host else {
            GPresentWarning("链接地址无效")
            defreezeInput()
            return
        }

        //准备上传的数据
        let pair = Reply(posterID: localUserID, topicID: topicID, link: link, host: host, title: titleLabel.stringValue, summary: summaryLabel.stringValue)
        guard let uploadData = try? JSONEncoder().encode(pair) else {
            debugPrint("uploadData is nil")
            defreezeInput()
            return
        }

        //配置request
        let url = gServerBaseURL.appendingPathComponent("api/replies/add")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = uploadData
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        //Task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            self.pTask = nil

            //处理错误
            if let errorT = error {
                GPresentWarning("错误: \(errorT.localizedDescription)")
                defreezeInput()
                return
            }
            guard let response = response as? HTTPURLResponse else {
                GPresentWarning("服务器返回无效的响应，请稍后再试。")
                defreezeInput()
                return
            }

            //结果处理
            switch response.statusCode {
            case 201:
                OperationQueue.main.addOperation {
                    gAppDelegate.dismissCurrentCtrller()
                }
                NotificationCenter.default.post(name: .BackFromPostArticle, object: BackType.submit)
            default:
                defreezeInput()
                if let dataT = data,let json = try? JSONSerialization.jsonObject(with: dataT), let jsonD = json as? Dictionary<String,Any>,let reason = jsonD["reason"] as? String {
                    GPresentWarning(reason)
                }
                else{
                    GPresentWarning("发布回复接口中无法识别的错误")
                }
            }
        }
        self.pTask = task
        task.resume()
    }


    @objc func cancleAction() {
        pTask?.cancel()
        gAppDelegate.dismissCurrentCtrller()
        NotificationCenter.default.post(name: .BackFromPostArticle, object: BackType.cancle)
    }


    enum BackType {
        case submit
        case cancle
    }
}


extension Notification.Name {
    static let BackFromPostArticle = Notification.Name.init("BackFromPostArticle")
}
