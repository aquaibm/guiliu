//
//  MainViewCtrller.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/6/27.
//  Copyright © 2018年 Moonlight. All rights reserved.
//

import Foundation
import AppKit
import SnapKit

class MainViewCtrller: NSViewController {
    
    var splitCtrller = SplitViewCtrller.init(nibName: nil, bundle: nil)
    
    fileprivate let pNotiObserverManager = FMNotificationManager()
    
    //创建栏
    var pCreateView: TopicCreateView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addChildViewController(splitCtrller)
        view.addSubview(splitCtrller.view)
        splitCtrller.view.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalToSuperview()
            maker.top.equalToSuperview()
        }
        
        pNotiObserverManager.addObserver(notificationName: .WillCreateTopic, fromObject: nil, queue: OperationQueue.main) { (noti) in
            self.presentCreateView()
        }
    }
    
    func presentCreateView() {
        guard pCreateView == nil else {
            return
        }
        
        pCreateView = TopicCreateView()
        view.addSubview(pCreateView!)
        pCreateView!.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        pCreateView?.pCancleButton.target = self
        pCreateView?.pCancleButton.action = #selector(cancleAction)
        pCreateView?.pSummitButton.target = self
        pCreateView?.pSummitButton.action = #selector(creatSummitAction)
    }
    
    @objc func cancleAction() {
        pCreateView?.removeFromSuperview()
        pCreateView = nil
    }
    
    @objc func creatSummitAction() {
        //前置检测
        guard let topicName = pCreateView?.pNameField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines), topicName.isEmpty == false else {
            return
        }
        
        let postURL = kServerBaseURL?.appendingPathComponent("api/topics/create")
        guard let url = postURL else {
            debugPrint("Url is nil")
            return
        }
        
        guard let localUserID = kUser?.id else {
            debugPrint("local user is nil")
            return
        }
        
        guard let auth = kAuth else {
            debugPrint("fail to authrization")
            return
        }
        
        //准备主题数据
        let descrip = pCreateView?.pDescrField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        let image = pCreateView?.pImageButton.layer?.contents as? NSImage
        let imageData = image?.tiffRepresentation
        let boundary = UUID().uuidString
        
        let body = NSMutableData()
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"name\"" + "\r\n\r\n")
        body.appendString(topicName + "\r\n")
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"creatorID\"" + "\r\n\r\n")
        body.appendString(String(localUserID) + "\r\n")
        
        if let str = descrip {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"description\"" + "\r\n\r\n")
            body.appendString(str + "\r\n")
        }
        
        if let data = imageData {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"avatar\"; filename=\"image.tiff\"" + "\r\n")
            body.appendString("Content-Type: image/tiff" + "\r\n\r\n")
            body.append(data)
            body.appendString("\r\n")
            debugPrint(data,data.fileExtension)
        }
        body.appendString("--\(boundary)--\r\n")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = Data(referencing: body)
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; charset=utf-8; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                debugPrint ("error: \(error)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                debugPrint("Invalid response")
                return
            }
            
            switch response.statusCode {
            case 200:
                OperationQueue.main.addOperation {
                    self.cancleAction()
                }
                guard let data = data, let newTopic = try? JSONDecoder().decode(Topic.self, from: data) else {
                    return
                }
                NotificationCenter.default.post(name: .DidCreateNewTopic, object: newTopic)
            default:
                do {
                    if let data = data,let json = try JSONSerialization.jsonObject(with: data) as? Dictionary<String,Any> {
                        debugPrint(json)
                    }
                    else{
                        debugPrint("创建主题接口中无法识别的错误")
                    }
                }
                catch {
                    debugPrint("Error deserializing JSON 12: \(error)")
                }
            }
        }
        task.resume()
    }
}



extension Notification.Name {
    static let DidCreateNewTopic = Notification.Name(rawValue: "DidCreateNewTopic")
}
