//
//  TopicsFetchProtocol+PerTopic.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/3/10.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension TopicsFetchProtocol {
    func getTopicIDsOf(_ page: Int, identifier: Date) {
        //前置检测
        guard let localUserID = gUser?.id else {
            GPresentWarning("没有有效的本地用户存在")
            return
        }
        guard let auth = gAuth else {
            GPresentWarning("没有有效的用户认证")
            return
        }

        var url = gServerBaseURL.appendingPathComponent(topicsURLComponentKey)
        url.appendPathComponent(String(localUserID))
        url.appendPathComponent(String(page))
        url.appendPathComponent(searchString)

        //Auth
        var request = URLRequest(url: url)
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")

        //标记开始，显示提示
        markFetching()
        if let count = pagesCount {
            showTipMessage("第\(page+1)页 / 共\(count+1)页")
        }
        else {
            showTipMessage("第\(page+1)页")
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //保证只继续处理最新的获取结果
            guard identifier == self.latestStamp else {
                return
            }
            
            //错误处理
            if let errorT = error {
                GPresentWarning("错误: \(errorT.localizedDescription)。程序稍后会自动重试。")
                self.retryLaterAfterError(identifier: identifier)
                return
            }
            guard let response = response as? HTTPURLResponse else {
                GPresentWarning("服务器返回无效的响应，程序稍后会自动重试。")
                self.retryLaterAfterError(identifier: identifier)
                return
            }

            //结果处理
            switch response.statusCode {
            case 200:
                //确保数据格式正确
                guard let dataT = data, let ids = try? JSONDecoder().decode(Array<Int>.self, from: dataT) else {
                    GPresentWarning("解码列表数据出错，程序稍后会自动重试。")
                    self.retryLaterAfterError(identifier: identifier)
                    return
                }

                //成功获取数据，然后需要将批次标记记录下来
                self.batchNumber = page

                //如果数量等于零，说明没有下一页了
                guard ids.count > 0 else {
                    self.showTipMessage("没有更多数据了")
                    return
                }

                //保存获取到的id，继续下一步
                self.topicIDs = ids
                self.fetchTopics(identifier)
            default:
                if let data = data,let json = try? JSONSerialization.jsonObject(with: data),let jsonD = json as? Dictionary<String,Any>,let reason = jsonD["reason"] as? String {
                    GPresentWarning(reason)
                    self.retryLaterAfterError(identifier: identifier)
                }
                else{
                    GPresentWarning("获取主题接口中无法识别的错误，程序稍后会自动重试。")
                    self.retryLaterAfterError(identifier: identifier)
                }
            }
        }
        task.resume()
    }

    func retryLaterAfterError(identifier: Date) {
        //保证只继续处理最新的获取结果
        guard identifier == self.latestStamp else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.getTopicIDsOf(self.batchNumber,identifier: Date())
        }
    }
}
