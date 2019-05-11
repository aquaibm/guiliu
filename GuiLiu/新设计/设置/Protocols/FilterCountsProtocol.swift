//
//  FilterCountsProtocol.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/2/11.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

protocol FilterCountsProtocol: FilterViewLayoutProtocol {
    var totalCounts: Int? {get set}
    var currentPage: Int {get set}
    var countRoute: String {get}
}



extension FilterCountsProtocol {
    func getListCounts() {
        //前置检测
        guard let localUserID = gUser?.id else {
            GPresentWarning("没有有效的本地用户存在")
            return
        }
        guard let auth = gAuth else {
            GPresentWarning("没有有效的用户认证")
            return
        }

        var url = gServerBaseURL.appendingPathComponent("api/users")
        url.appendPathComponent(countRoute)
        url.appendPathComponent(String(localUserID))

        //Auth
        var request = URLRequest(url: url)
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")

        //Task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            //错误处理
            if let errorT = error {
                debugPrint("错误: \(errorT.localizedDescription)。程序稍后会自动重试。")
                self.retryGetPagesCountLaterAfterError()
                return
            }
            guard let response = response as? HTTPURLResponse else {
                debugPrint("服务器返回无效的响应，程序稍后会自动重试。")
                self.retryGetPagesCountLaterAfterError()
                return
            }

            //结果处理
            switch response.statusCode {
            case 200:
                guard let dataT = data, let countStr = String(data: dataT, encoding: String.Encoding.utf8), let count = Int(countStr) else {
                    debugPrint("解码列表数据出错，程序稍后会自动重试。")
                    self.retryGetPagesCountLaterAfterError()
                    return
                }

                self.totalCounts = count
                OperationQueue.main.addOperation {
                    if count > 0 {
                        self.tipLabel.stringValue = "共\(count)条记录，当前第\(self.currentPage+1)页，共\(count/50 + 1)页。"
                    }
                    else {
                        self.tipLabel.stringValue = "当前记录为零。"
                    }
                }
            default:
                if let data = data,let json = try? JSONSerialization.jsonObject(with: data),let jsonD = json as? Dictionary<String,Any>,let reason = jsonD["reason"] as? String {
                    debugPrint(reason)
                    self.retryGetPagesCountLaterAfterError()
                }
                else{
                    debugPrint("获取主题接口中无法识别的错误，程序稍后会自动重试。")
                    self.retryGetPagesCountLaterAfterError()
                }
            }
        }
        task.resume()
    }

    func retryGetPagesCountLaterAfterError() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.getListCounts()
        }
    }
}
