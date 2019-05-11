//
//  BlinkCtrller+Delete.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/3/22.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension BLinkCtrller {
    func deleteBlockedLink(_ item: BlockedLink){
        //检测
        guard let auth = gAuth else {
            GPresentWarning("没有有效的用户认证")
            return
        }
        guard let itemID = item.id else {
            GPresentWarning("条目ID无效")
            return
        }

        //添加到deleting数组
        deletingArray.append(item)

        //组装URL
        var url = gServerBaseURL.appendingPathComponent("api/users")
        url.appendPathComponent("deleteblockedlink")
        url.appendPathComponent(String(itemID))

        //Auth认证
        var request = URLRequest(url: url)
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")

        //Task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //清理deleting数组
            guard let m = self.deletingArray.index(of: item) else {
                return
            }
            self.deletingArray.remove(at: m)

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
                OperationQueue.main.addOperation {
                    //更新tableview
                    guard let index = self.listArray.index(of: item) else {
                        debugPrint("Can't find BLink index")
                        return
                    }
                    self.listArray.remove(at: index)
                    self.tableView.removeRows(at: IndexSet.init(integer: index), withAnimation: .effectFade)

                }
            default:
                if let dataT = data,let json = try? JSONSerialization.jsonObject(with: dataT), let jsonD = json as? Dictionary<String,Any>,let reason = jsonD["reason"] as? String {
                    GPresentWarning(reason)
                }
                else{
                    GPresentWarning("删除链接过滤条目接口中无法识别的错误")
                }
            }
        }
        task.resume()
    }
}
