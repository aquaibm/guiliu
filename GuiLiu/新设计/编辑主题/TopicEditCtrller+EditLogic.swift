//
//  EditTopicCtrller+EditLogic.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/2/9.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension TopicEditCtrller {

    @objc func submitAction() {
        //前置检测
        guard let tp = topic, let tid = tp.id else {
            GPresentWarning("没有有效的主题可供编辑")
            return
        }

        guard let auth = gAuth else {
            GPresentWarning("没有有效的用户认证")
            return
        }

        markSubmiting()

        //准备主题数据
        let boundary = UUID().uuidString

        let body = NSMutableData()
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"id\"" + "\r\n\r\n")
        body.appendString(String(tid) + "\r\n")

        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"name\"" + "\r\n\r\n")
        body.appendString(tp.name + "\r\n")

        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"creatorID\"" + "\r\n\r\n")
        body.appendString(String(tp.creatorID) + "\r\n")

        if let str = tp.description {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"description\"" + "\r\n\r\n")
            body.appendString(str + "\r\n")
        }

        if let data = tp.avatar {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"avatar\"; filename=\"image.tiff\"" + "\r\n")
            body.appendString("Content-Type: image/tiff" + "\r\n\r\n")
            body.append(data)
            body.appendString("\r\n")
            debugPrint(data,data.fileExtension)
        }
        body.appendString("--\(boundary)--\r\n")

        let url = gServerBaseURL.appendingPathComponent("api/topics/update")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = Data(referencing: body)
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; charset=utf-8; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            self.markSubmitCompletion()

            if let errorT = error {
                GPresentWarning("错误: \(errorT.localizedDescription)")
                print(1,errorT)
                return
            }

            guard let response = response as? HTTPURLResponse else {
                GPresentWarning("服务器返回无效的响应，请稍后再试。")
                return
            }
            print(response.statusCode,HTTPURLResponse.localizedString(forStatusCode: response.statusCode))
            switch response.statusCode {
            case 200:
                OperationQueue.main.addOperation {
                    gAppDelegate.dismissCurrentCtrller()
                }
                NotificationCenter.default.post(name: .BackFromTopicEdit, object: tp)
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
                    print(2,error.localizedDescription)
                }
            }
        }
        task.resume()
    }

    @objc func cancleAction() {
        pTask?.cancel()
        gAppDelegate.dismissCurrentCtrller()
        NotificationCenter.default.post(name: .BackFromTopicEdit, object: nil)
    }

    func markSubmiting() {
        OperationQueue.main.addOperation {
            self.desInputLabel.isEditable = false
            self.imagePickerButton.isEnabled = false
            self.submitButton.isEnabled = false
            self.postSpin.startAnimation(nil)
        }
    }

    func markSubmitCompletion() {
        OperationQueue.main.addOperation {
            self.desInputLabel.isEditable = true
            self.imagePickerButton.isEnabled = true
            self.submitButton.isEnabled = true
            self.postSpin.stopAnimation(nil)
        }
    }
}



extension Notification.Name {
    static let BackFromTopicEdit = Notification.Name.init("BackFromEditTopic")
}
