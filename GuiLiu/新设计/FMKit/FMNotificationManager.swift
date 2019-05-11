//
//  NotificationsObserver.swift
//  CompanionSwift
//
//  Created by Li Fumin on 2016/10/19.
//  Copyright © 2016年 MoonLight. All rights reserved.
//

import Foundation

class FMNotificationManager
{
    private var pObservers = [AnyObject]()
    
    deinit
    {
        for observer in pObservers
        {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    func addObserver(notificationName:Notification.Name?, fromObject: AnyObject?, queue: OperationQueue?, block: @escaping (Notification)->Void)
    {
        let observer = NotificationCenter.default.addObserver(forName: notificationName, object: fromObject, queue: queue, using: block)
        pObservers.append(observer)
    }
    
    func addObserver(notificationNames:[Notification.Name], fromObject: AnyObject?, queue: OperationQueue?, block: @escaping (Notification)->Void)
    {
        for item in notificationNames
        {
            let observer = NotificationCenter.default.addObserver(forName: item, object: fromObject, queue: queue, using: block)
            pObservers.append(observer)
        }
    }
}
