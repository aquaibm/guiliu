//
//  TopicsFetchProtocol+TopicForID.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/3/10.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension TopicsFetchProtocol {
    func fetchTopics(_ identifier: Date) {
        guard let auth = gAuth else {
            GPresentWarning("没有有效的用户认证")
            return
        }

        let downloadGroup = DispatchGroup()
        for topicID in topicIDs {
            //组进入
            downloadGroup.enter()

            var url = gServerBaseURL.appendingPathComponent("api/topics/topicviaid")
            url.appendPathComponent(String(topicID))

            //Auth
            var request = URLRequest(url: url)
            request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")

            let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                guard let self = self else { return }

                //组离开
                downloadGroup.leave()

                //保证只继续处理最新的获取结果
                guard identifier == self.latestStamp else {
                    return
                }

                //错误处理
                if let errorT = error {
                    print("Topic ID: \(topicID),\(errorT.localizedDescription)")
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    print("Topic ID: \(topicID),response is nil")
                    return
                }

                //结果处理
                switch response.statusCode {
                case 200:
                    //确保数据格式正确
                    guard let dataT = data, let tp = try? JSONDecoder().decode(Topic.self, from: dataT) else {
                        print("Topic ID: \(topicID),返回格式不是Topic")
                        return
                    }
                    self.addTopic(tp)
                default:
                    if let data = data,let json = try? JSONSerialization.jsonObject(with: data),let jsonD = json as? Dictionary<String,Any>,let reason = jsonD["reason"] as? String {
                        print("Topic ID: \(topicID),\(reason),status code: \(response.statusCode)")
                    }
                    else{
                        print("Topic ID: \(topicID),无法识别的错误,status code: \(response.statusCode)")
                    }
                }
            }
            topicTasks.append(task)
            task.resume()
        }

        downloadGroup.notify(queue: DispatchQueue.main) {
            //保证只继续处理最新的获取结果
            guard identifier == self.latestStamp else {
                return
            }
            self.markFetchingEnd()
        }
    }
}
