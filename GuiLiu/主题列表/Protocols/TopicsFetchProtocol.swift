//
//  TopicsFetchProtocol.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/3/6.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

protocol TopicsFetchProtocol: TopicCollectionProtocol {
    var searchString: String {get set}

    var lastSearchString: String? {get set} //关键词和上次相同则不用重新查询响应的页数

    var latestStamp: Date? {get set}
    var pagesCount: Int? {get set}
    var batchNumber: Int {get set}
    var topicIDs: [Int] {get set}

    var topicTasks: [URLSessionDataTask] {get set} //被新获取请求覆盖时，便于取消余下的旧并发请求
    var concurrentTopicsQueue: DispatchQueue {get} //for concurrent thread safty.用于并发储存获取到的topic
    var topics: [Topic] {get set}

    var topicsURLComponentKey: String {get}
    var topicPagesCountURLComponentKey: String {get}
}


