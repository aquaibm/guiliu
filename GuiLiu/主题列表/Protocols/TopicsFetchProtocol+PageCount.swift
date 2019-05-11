//
//  TopicsFetchProtocol+PageCount.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/3/10.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension TopicsFetchProtocol {
    func getPagesCount(identifier: Date) {
        //前置检测
        guard let localUserID = gUser?.id else {
            GPresentWarning("没有有效的本地用户存在")
            return
        }
        guard let auth = gAuth else {
            GPresentWarning("没有有效的用户认证")
            return
        }

        var url = gServerBaseURL.appendingPathComponent(topicPagesCountURLComponentKey)
        url.appendPathComponent(String(localUserID))
        url.appendPathComponent(searchString)

        //Auth
        var request = URLRequest(url: url)
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")

        //Task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //保证只继续处理最新的获取结果
            guard identifier == self.latestStamp else {
                return
            }

            //错误处理
            if let errorT = error {
                debugPrint("错误: \(errorT.localizedDescription)。程序稍后会自动重试。")
                self.retryGetPagesCountLaterAfterError(identifier: identifier)
                return
            }
            guard let response = response as? HTTPURLResponse else {
                debugPrint("服务器返回无效的响应，程序稍后会自动重试。")
                self.retryGetPagesCountLaterAfterError(identifier: identifier)
                return
            }

            //结果处理
            switch response.statusCode {
            case 200:
                guard let dataT = data, let countStr = String(data: dataT, encoding: String.Encoding.utf8), let count = Int(countStr) else {
                    debugPrint("解码列表数据出错，程序稍后会自动重试。")
                    self.retryGetPagesCountLaterAfterError(identifier: identifier)
                    return
                }

                self.pagesCount = count
            default:
                if let data = data,let json = try? JSONSerialization.jsonObject(with: data),let jsonD = json as? Dictionary<String,Any>,let reason = jsonD["reason"] as? String {
                    debugPrint(reason)
                    self.retryGetPagesCountLaterAfterError(identifier: identifier)
                }
                else{
                    debugPrint("获取主题接口中无法识别的错误，程序稍后会自动重试。")
                    self.retryGetPagesCountLaterAfterError(identifier: identifier)
                }
            }
        }
        task.resume()
    }

    private func retryGetPagesCountLaterAfterError(identifier: Date) {
        //保证只继续处理最新的获取结果
        guard identifier == self.latestStamp else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.getPagesCount(identifier: identifier)
        }
    }
}
