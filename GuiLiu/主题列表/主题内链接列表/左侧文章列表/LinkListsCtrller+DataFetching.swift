//
//  ArticlesListsCtrller+DataFetching.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/11/1.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension LinkListsCtrller {
    func fetchArticles(of topic: Topic) {
        pTopic = topic
        getFirstBatchReplies()
    }

    @objc func getFirstBatchReplies() {
        //前置检测
        guard let topicID = pTopic?.id else {
            GPresentWarning("主题ID无效")
            return
        }
        guard let currentUserID = gUser?.id else {
            GPresentWarning("没有有效的本地用户存在")
            return
        }
        guard let auth = gAuth else {
            GPresentWarning("没有有效的用户认证")
            return
        }

        //标记最近的获取
        let ident = Date()
        pIdentifier = ident
        spin.startAnimation(nil)

        //清除旧有的信息
        pLinks.removeAll()
        pTableView.reloadData()

        //组装URL
        var url = gServerBaseURL.appendingPathComponent("api/replies/firstbatch")
        url.appendPathComponent(String(topicID))
        url.appendPathComponent(String(currentUserID))

        //Auth
        var request = URLRequest(url: url)
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) {[weak self] (data, response, error) in
            guard let self = self else { return}

            //已经不是最新发起的获取的话，就不继续处理
            guard ident == self.pIdentifier else {return}

            //
            OperationQueue.main.addOperation {
                self.spin.stopAnimation(nil)
            }

            //错误处理
            if let errorT = error {
                GPresentWarning("错误: \(errorT.localizedDescription)")
                return
            }
            guard let response = response as? HTTPURLResponse else {
                GPresentWarning("服务器返回无效的响应，请稍后再试。")
                return
            }

            //分情况处理
            switch response.statusCode {
            case 200:
                guard let dataT = data,let replies = try? JSONDecoder().decode(Array<Reply>.self, from: dataT) else {
                    GPresentWarning("获取主题回复接口中无法获得有效数据")
                    return
                }

                //附上新获取的数据
                let singleArr = replies.filterDuplicates {l,r in //过滤重复的链接
                    return l.link == r.link
                }
                self.pLinks = SynchronizedArray(singleArr)
                OperationQueue.main.addOperation {
                    self.pTableView.reloadData()

                    //默认选中第一个
                    guard replies.count > 0 else {return}
                    self.pTableView.selectRowIndexes(IndexSet(arrayLiteral: 0), byExtendingSelection: false)
                }
            default:
                if let dataT = data,let json = try? JSONSerialization.jsonObject(with: dataT), let jsonD = json as? Dictionary<String,Any>,let reason = jsonD["reason"] as? String {
                    GPresentWarning(reason)
                }
                else{
                    GPresentWarning("获取主题回复接口中无法识别的错误")
                }
            }
        }
        task.resume()
    }

    @objc func getNewerReplies() {
        //前置检测
        guard let topicID = pTopic?.id else {
            GPresentWarning("主题ID无效")
            return
        }
        guard let currentUserID = gUser?.id else {
            GPresentWarning("没有有效的本地用户存在")
            return
        }
        guard let firstReplyID = pLinks.first?.id else {
            debugPrint("lastReplyID is nil.")
            getFirstBatchReplies()
            return
        }
        guard let auth = gAuth else {
            GPresentWarning("没有有效的用户认证")
            return
        }

        //标记最近的获取
        let ident = Date()
        pIdentifier = ident
        spin.startAnimation(nil)

        //清除旧有的信息
        let arrayCopy = pLinks.all //一旦获取到的数量不够20个，会从这里面抽取补充
        pLinks.removeAll()
        pTableView.reloadData()

        //以pReplies第一个reply为标记点，获取更新的数据
        var url = gServerBaseURL.appendingPathComponent("api/replies/newer")
        url.appendPathComponent(String(topicID))
        url.appendPathComponent(String(currentUserID))
        url.appendPathComponent(String(firstReplyID))

        //Auth
        var request = URLRequest(url: url)
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return}

            //已经不是最新发起的获取的话，就不继续处理
            guard ident == self.pIdentifier else {return}

            //
            OperationQueue.main.addOperation {
                self.spin.stopAnimation(nil)
            }

            //错误处理
            if let errorT = error {
                GPresentWarning("错误: \(errorT.localizedDescription)")
                return
            }
            guard let response = response as? HTTPURLResponse else {
                GPresentWarning("服务器返回无效的响应，请稍后再试。")
                return
            }

            //分情况处理
            switch response.statusCode {
            case 200:
                guard let dataT = data,var replies = try? JSONDecoder().decode(Array<Reply>.self, from: dataT) else {
                    GPresentWarning("获取更新回复接口无法获取有效的数据")
                    return
                }

                //让最新的在最前
                replies.reverse()

                //附上新获取的数据
                var tempArray = replies + arrayCopy
                tempArray = tempArray.filterDuplicates {l,r in //过滤重复的链接
                    return l.link == r.link
                }
                tempArray = Array(tempArray.prefix(20))
                self.pLinks = SynchronizedArray(tempArray)

                //刷新tableview
                OperationQueue.main.addOperation {
                    let set = IndexSet.init(integersIn: 0..<tempArray.endIndex)
                    self.pTableView.insertRows(at: set, withAnimation: .slideDown)
                }

            default:
                if let dataT = data,let json = try? JSONSerialization.jsonObject(with: dataT),let jsonD = json as? Dictionary<String,Any>,let reason = jsonD["reason"] as? String{
                    GPresentWarning(reason)
                }
                else{
                    GPresentWarning("获取更新回复接口中无法识别的错误")
                }
            }
        }
        task.resume()
    }

    @objc func getOlderReplies() {
        //前置检测
        guard let topicID = pTopic?.id else {
            GPresentWarning("主题ID无效")
            return
        }
        guard let currentUserID = gUser?.id else {
            GPresentWarning("没有有效的本地用户存在")
            return
        }
        guard let lastReplyID = pLinks.last?.id else {
            debugPrint("firstReplyID is nil.")
            getFirstBatchReplies()
            return
        }
        guard let auth = gAuth else {
            GPresentWarning("没有有效的用户认证")
            return
        }

        //标记最近的获取
        let ident = Date()
        pIdentifier = ident
        spin.startAnimation(nil)

        //清除旧有的信息
        let arrayCopy = pLinks.all //一旦获取到的数量不够20个，会从这里面抽取补充
        pLinks.removeAll()
        pTableView.reloadData()

        //以pReplies最后一个reply为标记点，获取早前的数据
        var url = gServerBaseURL.appendingPathComponent("api/replies/older")
        url.appendPathComponent(String(topicID))
        url.appendPathComponent(String(currentUserID))
        url.appendPathComponent(String(lastReplyID))

        //Auth
        var request = URLRequest(url: url)
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) {[weak self] (data, response, error) in
            guard let self = self else { return}

            //已经不是最新发起的获取的话，就不继续处理
            guard ident == self.pIdentifier else {return}

            //
            OperationQueue.main.addOperation {
                self.spin.stopAnimation(nil)
            }

            //错误处理
            if let errorT = error {
                GPresentWarning("错误: \(errorT.localizedDescription)")
                return
            }
            guard let response = response as? HTTPURLResponse else {
                GPresentWarning("服务器返回无效的响应，请稍后再试。")
                return
            }

            //分情况处理
            switch response.statusCode {
            case 200:
                guard let dataT = data,var replies = try? JSONDecoder().decode(Array<Reply>.self, from: dataT) else {
                    GPresentWarning("获取稍前回复接口无法获得有效数据")
                    return
                }

                //让最新的在最前
                replies.reverse()

                //附上新获取的数据
                var tempArray =  arrayCopy + replies
                tempArray = tempArray.filterDuplicates {l,r in //过滤重复的链接
                    return l.link == r.link
                }
                tempArray = Array(tempArray.suffix(20))
                self.pLinks = SynchronizedArray(tempArray)

                //刷新tableview
                OperationQueue.main.addOperation {
                    let set = IndexSet.init(integersIn: 0..<tempArray.endIndex)
                    self.pTableView.insertRows(at: set, withAnimation: .slideDown)
                }
            default:
                if let dataT = data,let json = try? JSONSerialization.jsonObject(with: dataT),let jsonD = json as? Dictionary<String,Any>,let reason = jsonD["reason"] as? String {
                    GPresentWarning(reason)
                }
                else{
                    GPresentWarning("获取主题回复接口中无法识别的错误")
                }
            }
        }
        task.resume()
    }

    func removeDuplicatedItems(in array: [Reply]) {
        
    }
}
