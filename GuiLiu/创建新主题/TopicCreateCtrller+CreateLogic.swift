//
//  CreateTopicCtrller+CreateLogic.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/12/13.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension TopicCreateCtrller {
    @objc func submitAction() {
        //前置检测
        let topicName = titleInputLabel.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard topicName.isEmpty == false else {
            GPresentWarning("主题名称不能为空")
            return
        }

        guard let localUserID = gUser?.id else {
            GPresentWarning("没有有效的本地用户存在")
            return
        }

        guard let auth = gAuth else {
            GPresentWarning("没有有效的用户认证")
            return
        }

        //标记开始
        markSubmiting()

        //准备主题数据
        let descrip = desInputLabel.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        let image = imageV.layer?.contents as? NSImage
        let imageData = image?.compressedJPEGRepresentation
        let boundary = UUID().uuidString

        let body = NSMutableData()
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"name\"" + "\r\n\r\n")
        body.appendString(topicName + "\r\n")

        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"creatorID\"" + "\r\n\r\n")
        body.appendString(String(localUserID) + "\r\n")

        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"description\"" + "\r\n\r\n")
        body.appendString(descrip + "\r\n")

        if let data = imageData {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"avatar\"; filename=\"image.tiff\"" + "\r\n")
            body.appendString("Content-Type: image/tiff" + "\r\n\r\n")
            body.append(data)
            body.appendString("\r\n")
            debugPrint(data,data.fileExtension)
        }
        body.appendString("--\(boundary)--\r\n")

        let url = gServerBaseURL.appendingPathComponent("api/topics/create")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = Data(referencing: body)
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; charset=utf-8; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //最后标记结束
            defer {
                self.markSubmitCompletion()
            }

            if let errorT = error {
                GPresentWarning("错误: \(errorT.localizedDescription)")
                return
            }

            guard let response = response as? HTTPURLResponse else {
                GPresentWarning("服务器返回无效的响应，请稍后再试。")
                return
            }

            switch response.statusCode {
            case 200:
                guard let data = data, let newTopic = try? JSONDecoder().decode(Topic.self, from: data) else {
                    GPresentWarning("服务器返回无效的主题数据，请稍后再试。")
                    return
                }
                OperationQueue.main.addOperation {
                    gAppDelegate.dismissCurrentCtrller()
                }
                NotificationCenter.default.post(name: .BackFromTopicCreate, object: newTopic)
            default:
                do {
                    if let data = data,let json = try JSONSerialization.jsonObject(with: data) as? Dictionary<String,Any>,let reason = json["reason"] as? String {
                        GPresentWarning(reason)
                    }
                    else{
                        GPresentWarning("创建主题接口中无法识别的错误")
                    }
                }
                catch {
                    GPresentWarning("错误: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }

    @objc func cancleAction() {
        pTask?.cancel()
        OperationQueue.main.addOperation {
            gAppDelegate.dismissCurrentCtrller()
        }
        NotificationCenter.default.post(name: .BackFromTopicCreate, object: nil)
    }

    func markSubmiting() {
        OperationQueue.main.addOperation {
            self.titleInputLabel.isEditable = false
            self.desInputLabel.isEditable = false
            self.imagePickerButton.isEnabled = false
            self.submitButton.isEnabled = false
            self.postSpin.startAnimation(nil)
        }
    }

    func markSubmitCompletion() {
        OperationQueue.main.addOperation {
            self.titleInputLabel.isEditable = true
            self.desInputLabel.isEditable = true
            self.imagePickerButton.isEnabled = true
            self.submitButton.isEnabled = true
            self.postSpin.stopAnimation(nil)
        }
    }
}


extension Notification.Name {
    static let BackFromTopicCreate = Notification.Name.init("BackFromCreateTopic")
}
