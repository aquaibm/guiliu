//
//  Reply.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/7/2.
//  Copyright © 2018年 Moonlight. All rights reserved.
//

import Foundation


struct Reply: Codable,Hashable {
    
    var id: Int?

    var posterID: Int
    var topicID: Int
    var link: String
    
    var host: String
    var title: String
    var summary: String
    
    var canBlock = true
    
    var createdAt: String?
    var updatedAt: String?

    func hash(into hasher: inout Hasher) {
        hasher.combine(id!)
    }
    
    init(posterID: Int, topicID: Int, link: String,host: String,title: String,summary: String) {
        self.posterID = posterID
        self.topicID = topicID
        self.link = link
        
        self.host = host
        self.title = title
        self.summary = summary
    }

}
