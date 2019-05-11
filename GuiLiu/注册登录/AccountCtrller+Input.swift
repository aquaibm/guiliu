//
//  Account+Input.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/12/16.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit


extension AccountCtrller {
    func saveAccountInputInfo() {
        let presentingView: NSView
        if methodType == .login {
            presentingView = directlyView
        }
        else if methodType == .register {
            presentingView = newcomerView
        }
        else {
            return
        }

        let nameLabel = presentingView.viewWithTag(1001) as? NSTextField
        let pwLabel = presentingView.viewWithTag(1002) as? NSSecureTextField
        let cpwLabel = presentingView.viewWithTag(1003) as? NSSecureTextField
        accountInfo = (nameLabel?.stringValue,pwLabel?.stringValue,cpwLabel?.stringValue)
    }

    func restoreAccountInputInfo() {
        let presentingView: NSView
        if methodType == .login {
            presentingView = directlyView
        }
        else if methodType == .register {
            presentingView = newcomerView
        }
        else {
            return
        }

        let nameLabel = presentingView.viewWithTag(1001) as? NSTextField
        let pwLabel = presentingView.viewWithTag(1002) as? NSSecureTextField
        let cpwLabel = presentingView.viewWithTag(1003) as? NSSecureTextField
        if let email = accountInfo.0 {
            nameLabel?.stringValue = email
        }
        if let pw = accountInfo.1 {
            pwLabel?.stringValue = pw
        }
        if let pwc = accountInfo.2 {
            cpwLabel?.stringValue = pwc
        }
    }

    func checkEmail() -> (isValid: Bool,errorMessage: String?) {
        guard let _ = accountInfo.0?.emailValidate() else {
            return (false, "不是有效的邮箱地址")
        }
        return (true,nil)
    }

    func checkPassword() -> (isValid: Bool, errorMessage: String?) {
        guard let _ = accountInfo.1?.passwordValidate() else {
            return (false, "无效的密码（正确长度为6-12位")
        }
        return (true,nil)
    }

    func getKeychainInfo() -> (String,String)? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: "GuiLiuAppLogin",
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]
        var itemRef: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &itemRef)
        if status == errSecSuccess,
            let existingItem = itemRef as? [String : Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8),
            let account = existingItem[kSecAttrAccount as String] as? String {
            return (account,password)
        }
        else {
            return nil
        }
    }
}
