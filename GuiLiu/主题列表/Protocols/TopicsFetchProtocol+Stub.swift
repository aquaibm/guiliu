//
//  TopicsFetchProtocol.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/12/29.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit


extension TopicsFetchProtocol {

    func search() {
        searchString = searchView.searchString

        //保存最新搜索时间作为识别符
        latestStamp = Date()
        prepareNewFetches(identifier: latestStamp!)
        getTopicIDsOf(0,identifier: latestStamp!)
    }

    func fetchTopicsOf(_ page: Int) {
        searchString = ""

        //保存最新搜索时间作为识别符
        latestStamp = Date()
        prepareNewFetches(identifier: latestStamp!)
        getTopicIDsOf(page, identifier: latestStamp!)
    }

    private func prepareNewFetches(identifier: Date) {
        if lastSearchString != searchString { //当前关键词的第一次获取
            pagesCount = nil //重置当前关键词的页数
            getPagesCount(identifier: identifier) //获取当前关键词的页数

            batchNumber = 0 //重置当前关键词的批次

            lastSearchString = searchString //记录最新的搜索关键词
        }

        //清除旧批次的操作和状态
        topicTasks.forEach{
            guard $0.state == .running || $0.state == .suspended else { return }
            $0.cancel()
        }
        topicTasks.removeAll()
        topicIDs.removeAll()
        removeAllTopic()
        OperationQueue.main.addOperation {
            self.progressSpin.stopAnimation(nil)
        }
    }

    func markFetching() {
        OperationQueue.main.addOperation {
            self.progressSpin.startAnimation(nil)
        }
    }

    func markFetchingEnd() {
        OperationQueue.main.addOperation {
            self.progressSpin.stopAnimation(nil)
        }
    }

    func showTipMessage(_ tip: String) {
        OperationQueue.main.addOperation {
            self.tipLabel.stringValue = tip
            self.tipLabel.layer?.opacity = 1.0

            //fade in
            let showAnimate = CABasicAnimation(keyPath: "opacity")
            showAnimate.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            showAnimate.fromValue = 0
            showAnimate.toValue = 1.0
            showAnimate.duration = 1.0
            showAnimate.isRemovedOnCompletion = false
            self.tipLabel.layer?.add(showAnimate, forKey: nil)

            //fade out
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
                //防止有新的提示进来
                guard self.tipLabel.stringValue == tip else {
                    return
                }
                let hideAnimate = CABasicAnimation(keyPath: "opacity")
                hideAnimate.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                hideAnimate.fromValue = 1.0
                hideAnimate.toValue = 0.0
                hideAnimate.duration = 1.0
                self.tipLabel.layer?.add(hideAnimate, forKey: nil)
                self.tipLabel.layer?.opacity = 0
            }
        }
    }
}
