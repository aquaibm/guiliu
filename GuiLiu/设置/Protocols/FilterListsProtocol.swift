//
//  FilterListsProtocol.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/2/14.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

protocol FilterListsProtocol: FilterCountsProtocol {
    associatedtype Item: Decodable
    var isFetching: Bool {get set}
    var isFetched: Bool {get set}
    var listsRoute: String {get}
    var listArray: [Item] {get set}
    var deletingArray: [Item] {get set}
    var currentPage: Int {get set}
}


extension FilterListsProtocol {
    func getBlockedListOf(page: Int) {
        if isFetching {return}

        //检测
        guard let auth = gAuth else {
            GPresentWarning("没有有效的用户认证")
            return
        }

        guard let localUserID = gUser?.id else {
            GPresentWarning("没有有效的本地用户存在")
            return
        }

        //组装URL
        var url = gServerBaseURL.appendingPathComponent("api/users")
        url.appendPathComponent(listsRoute)
        url.appendPathComponent(String(localUserID))
        url.appendPathComponent(String(page))

        //Auth认证
        var request = URLRequest(url: url)
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")

        //Task
        markFetchStart()
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            self.markFetchEnd()
            //错误检测
            if let errorT = error {
                GPresentWarning("错误: \(errorT.localizedDescription)")
                return
            }

            guard let response = response as? HTTPURLResponse else {
                GPresentWarning("服务器返回无效的响应，请稍后再试。")
                return
            }

            //根据status code处置
            switch response.statusCode {
            case 200:
                //解码数据
                guard let dataT = data, let list = try? JSONDecoder().decode(Array<Item>.self, from: dataT) else {
                    GPresentWarning("解码过滤列表数据失败")
                    return
                }

                //成功获取数据，然后需要将批次标记记录下来
                self.currentPage = page
                self.isFetched = true

                self.listArray = list
                OperationQueue.main.addOperation {
                    if let count = self.totalCounts {
                        if count > 0 {
                            self.tipLabel.stringValue = "共\(count)条记录，当前第\(self.currentPage+1)页，共\(count/50 + 1)页。"
                        }
                        else {
                            self.tipLabel.stringValue = "当前记录为零。"
                        }
                    }

                    self.tableView.reloadData()
                }

            default:
                if let dataT = data,let json = try? JSONSerialization.jsonObject(with: dataT), let jsonD = json as? Dictionary<String,Any>,let reason = jsonD["reason"] as? String {
                    GPresentWarning(reason)
                }
                else{
                    GPresentWarning("获取过滤列表接口中无法识别的错误")
                }
            }
        }
        task.resume()
    }

    func markFetchStart() {
        OperationQueue.main.addOperation {
            self.isFetching = true
            self.spin.startAnimation(nil)

            //清除当前table数据
            self.listArray.removeAll()
            self.tableView.reloadData()
        }
    }

    func markFetchEnd() {
        OperationQueue.main.addOperation {
            self.isFetching = false
            self.spin.stopAnimation(nil)
        }
    }

    func showTipMessage(_ tip: String) {
        OperationQueue.main.addOperation {
            self.bottomTipLabel.stringValue = tip
            self.bottomTipLabel.layer?.opacity = 1.0

            //fade in
            let showAnimate = CABasicAnimation(keyPath: "opacity")
            showAnimate.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            showAnimate.fromValue = 0
            showAnimate.toValue = 1.0
            showAnimate.duration = 1.0
            showAnimate.isRemovedOnCompletion = false
            self.bottomTipLabel.layer?.add(showAnimate, forKey: nil)

            //fade out
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
                //防止有新的提示进来
                guard self.bottomTipLabel.stringValue == tip else {
                    return
                }
                let hideAnimate = CABasicAnimation(keyPath: "opacity")
                hideAnimate.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                hideAnimate.fromValue = 1.0
                hideAnimate.toValue = 0.0
                hideAnimate.duration = 1.0
                self.bottomTipLabel.layer?.add(hideAnimate, forKey: nil)
                self.bottomTipLabel.layer?.opacity = 0
            }
        }
    }
}
