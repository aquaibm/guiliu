//
//  AccountManagerCtrller+Actions.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/1/15.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension AccountManagerCtrller {
    func fillTheFormWithUserProfile() {
        emailLabel.stringValue = gUser?.email ?? ""
        nickLabel.stringValue = gUser?.nickName ?? ""

        lastNickName = nickLabel.stringValue //不是手动输入不会触发响应的notification，所以要特殊处理
    }

    @objc func saveProfile() {
        //检查用户是否更改过
        if lastNickName == gUser?.nickName ?? "", lastCurrentPassword.isEmpty == true, lastNewPassword.isEmpty == true, lastConfirmNewPassword.isEmpty == true {
            return
        }

        guard let localUser = gUser,let localUserId = localUser.id else {
            GPresentWarning("没有有效的本地用户")
            return
        }

        guard let auth = gAuth else {
            GPresentWarning("没有有效的用户认证")
            return
        }

        var profile = UserProfile(id: localUserId)

        //昵称改吗？
        if lastNickName.isEmpty == false {
            profile.userNickName = lastNickName
        }

        //现密码，新密码合法吗？
        if lastCurrentPassword.isEmpty == false || lastNewPassword.isEmpty == false || lastConfirmNewPassword.isEmpty == false {
            guard lastCurrentPassword.passwordValidate() != nil else {
                GPresentWarning("现今密码输入长度错误（6-12个字符）")
                return
            }

            guard lastNewPassword.passwordValidate() != nil else {
                GPresentWarning("新密码输入长度错误（6-12个字符）")
                return
            }

            guard lastConfirmNewPassword == lastNewPassword else {
                GPresentWarning("确认的新密码不一致")
                return
            }

            profile.userPWord = lastCurrentPassword
            profile.userNewPWord = lastNewPassword
        }

        guard let uploadData = try? JSONEncoder().encode(profile) else {
            debugPrint("uploadData is nil")
            return
        }

        //暂时使按钮失效，防止重复误点击
        OperationQueue.main.addOperation {
            self.lockUI()
        }

        let url = gServerBaseURL.appendingPathComponent("api/users/modifyprofile")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = uploadData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            OperationQueue.main.addOperation {
                self.unlockUI()
            }

            if let errorT = error {
                GPresentWarning("错误: \(errorT.localizedDescription)")
                return
            }

            guard let response = response as? HTTPURLResponse else {
                GPresentWarning("服务器返回无效的响应，请稍后再试。")
                return
            }

            switch response.statusCode {
            case 200:
                GPresentWarning("修改用户信息成功")

                //更新本地用户信息
                if self.lastNickName.isEmpty == false {
                    gUser?.nickName = self.lastNickName
                }
                if self.lastNewPassword.isEmpty == false {
                    gUser?.password = self.lastNewPassword

                    //更新keychain
                    let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                                kSecAttrService as String: "GuiLiuAppLogin"]
                    let attributes: [String: Any] = [kSecAttrAccount as String: localUser.email,
                                                     kSecValueData as String: self.lastNewPassword.data(using: String.Encoding.utf8)!]
                    let _ = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
                }

            default:
                guard let dataT = data,let json = try? JSONSerialization.jsonObject(with: dataT),let jsonD = json as? Dictionary<String,Any>,let reason = jsonD["reason"] as? String else {
                    GPresentWarning("解码响应数据失败")
                    return
                }
                GPresentWarning(reason)
            }
        }
        task.resume()
    }

    @objc func logout() {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: "GuiLiuAppLogin"]
        let status = SecItemDelete(query as CFDictionary)
        lockUI()
        guard status == errSecSuccess || status == errSecItemNotFound else {
            unlockUI()
            return
        }

        gAppDelegate.dismissAllCtrllers()
        gAppDelegate.presentViewCtrller(AccountCtrller(nibName: nil, bundle: nil))
    }

    func lockUI() {
        nickLabel.isEditable = false
        pwLabel.isEditable = false
        npwLabel.isEditable = false
        cnpwLabel.isEditable = false
        saveBtn.isEnabled = false
        logoutBtn.isEnabled = false
        saveSpin.startAnimation(nil)
    }

    func unlockUI() {
        nickLabel.isEditable = true
        pwLabel.isEditable = true
        npwLabel.isEditable = true
        cnpwLabel.isEditable = true
        saveBtn.isEnabled = true
        logoutBtn.isEnabled = true
        saveSpin.stopAnimation(nil)
    }
}
