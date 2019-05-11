//
//  AccountCtrller+AccountLogic.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/12/16.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit


extension AccountCtrller {
    @objc func returnKeyAction() {
        if methodType == .login {
            loginDirectly()
        }
        else if methodType == .register {
            registerToLogin()
        }
    }

    @objc func loginDirectly() {
        saveAccountInputInfo()

        guard let email = accountInfo.0?.emailValidate() else {
            GPresentWarning("不是有效的邮箱地址")
            return
        }
        guard let password = accountInfo.1?.passwordValidate() else {
            GPresentWarning("不是有效长度的密码(应为6-12位)")
            return
        }

        markConnecting()
        let user = User(email: email, password: password)
        finalLogin(user)
    }


    @objc func registerToLogin() {
        saveAccountInputInfo()

        guard let email = accountInfo.0?.emailValidate() else {
            GPresentWarning("不是有效的邮箱地址")
            return
        }
        guard let password = accountInfo.1?.passwordValidate() else {
            GPresentWarning("不是有效长度的密码(应为6-12位)")
            return
        }
        guard accountInfo.1 == accountInfo.2 else {
            GPresentWarning("确认密码不一致")
            return
        }

        let user = User(email: email, password: password)
        guard let uploadData = try? JSONEncoder().encode(user) else {
            debugPrint("uploadData is nil")
            return
        }

        markConnecting()
        let url = gServerBaseURL.appendingPathComponent("api/users/register")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = uploadData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let errorT = error {
                GPresentWarning("错误: \(errorT.localizedDescription)")
                self.markConnectionFinish()
                return
            }

            guard let response = response as? HTTPURLResponse else {
                GPresentWarning("服务器返回无效的响应，请稍后再试。")
                self.markConnectionFinish()
                return
            }

            switch response.statusCode {
            case 201:
                self.finalLogin(user)
            default:
                self.markConnectionFinish()
                do {
                    if let data = data,let json = try JSONSerialization.jsonObject(with: data) as? Dictionary<String,Any> ,let reason = json["reason"] as? String{
                        GPresentWarning(reason)
                    }
                    else{
                        GPresentWarning("注册接口中无法识别的错误")
                    }
                }
                catch {
                    GPresentWarning("错误: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }

    
    func finalLogin(_ user: User) {
        guard let uploadData = try? JSONEncoder().encode(user) else {
            debugPrint("uploadData is nil")
            self.markConnectionFinish()
            return
        }

        let url = gServerBaseURL.appendingPathComponent("api/users/login")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = uploadData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let errorT = error {
                GPresentWarning("错误: \(errorT.localizedDescription)")
                self.markConnectionFinish()
                return
            }

            guard let response = response as? HTTPURLResponse else {
                GPresentWarning("服务器返回无效的响应，请稍后再试。")
                self.markConnectionFinish()
                return
            }

            switch response.statusCode {
            case 200:

                guard let dataT = data, let userRe = try? JSONDecoder().decode(User.self, from: dataT) else {
                    GPresentWarning("解码返回的用户数据失败")
                    self.markConnectionFinish()
                    return
                }
                gUser = userRe

                //替换加密密码
                gUser?.password = user.password

                //如果和keychain保存的账号或密码不同，则更新对应的数据
                let m = self.getKeychainInfo()
                if let info = m, user.email == info.0, user.password != info.1 {
                    //更新账号
                    let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                                kSecAttrService as String: "GuiLiuAppLogin"]
                    let attributes: [String: Any] = [kSecAttrAccount as String: user.email,
                                                     kSecValueData as String: user.password.data(using: String.Encoding.utf8)!]
                    let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
                    debugPrint(1,status)
                }
                else if let info = m, user.email != info.0 {
                    //删除先前的账号，再储存新的
                    let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                                kSecAttrService as String: "GuiLiuAppLogin"]
                    let status = SecItemDelete(query as CFDictionary)
                    debugPrint(2,status)

                    let query2: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                                 kSecAttrService as String: "GuiLiuAppLogin",
                                                 kSecAttrAccount as String: user.email,
                                                 kSecValueData as String: user.password.data(using: String.Encoding.utf8)!]
                    let status2 = SecItemAdd(query2 as CFDictionary, nil)
                    debugPrint(3,status2)
                }
                else if m == nil {
                    //Keychain没有数据，则增加新的
                    let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                                kSecAttrService as String: "GuiLiuAppLogin",
                                                kSecAttrAccount as String: user.email,
                                                kSecValueData as String: user.password.data(using: String.Encoding.utf8)!]
                    let status = SecItemAdd(query as CFDictionary, nil)
                    debugPrint(4,status)
                }

                self.markConnectionFinish()
                OperationQueue.main.addOperation {
                    gAppDelegate.dismissCurrentCtrller()
                    gAppDelegate.presentViewCtrller(TopicsContainerCtrller.init(nibName: nil, bundle: nil))
                }

            default:
                self.markConnectionFinish()
                guard let dataT = data,let json = try? JSONSerialization.jsonObject(with: dataT),let jsonD = json as? Dictionary<String,Any>,let reason = jsonD["reason"] as? String else {
                    GPresentWarning("解码响应数据失败")
                    return
                }
                GPresentWarning(reason)
            }
        }
        task.resume()
    }


    func markConnecting() {
        OperationQueue.main.addOperation {
            self.pSpin.startAnimation(nil)
            self.topButton.isEnabled = false
            self.botButton.isEnabled = false

            let presentingView: NSView
            if self.methodType == .login {
                presentingView = self.directlyView
            }
            else if self.methodType == .register {
                presentingView = self.newcomerView
            }
            else {
                return
            }
            let button = presentingView.viewWithTag(1004) as? NSButton
            button?.isEnabled = false
        }
    }

    func markConnectionFinish() {
        OperationQueue.main.addOperation {
            self.pSpin.stopAnimation(nil)
            self.topButton.isEnabled = true
            self.botButton.isEnabled = true

            let presentingView: NSView
            if self.methodType == .login {
                presentingView = self.directlyView
            }
            else if self.methodType == .register {
                presentingView = self.newcomerView
            }
            else {
                return
            }
            let button = presentingView.viewWithTag(1004) as? NSButton
            button?.isEnabled = true
        }
    }
}
