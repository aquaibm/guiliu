//
//  AccountManagerCtrller+Validations.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/1/14.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension AccountManagerCtrller {
    func didInputNickName() {
        lengthHelperLabel.stringValue = nickLabel.stringValue
        lengthHelperLabel.sizeToFit()
        if lengthHelperLabel.bounds.width >= 160.0 {
            //字符串如果大于一定长度，将替换为上一个临界字符串
            nickLabel.stringValue = lastNickName
        }
        else {
            //记录最新的字符串
            lastNickName = nickLabel.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        }

    }

    func didInputCurrentPassword() {
        if pwLabel.stringValue.count > 12 {
            //字符串如果大于12个，将替换为上一个临界字符串
            pwLabel.stringValue = lastCurrentPassword
        }
        else {
            //记录最新的字符串
            lastCurrentPassword = pwLabel.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }

    func didInputNewPassword() {
        if npwLabel.stringValue.count > 12 {
            //字符串如果大于12个，将替换为上一个临界字符串
            npwLabel.stringValue = lastNewPassword
        }
        else {
            //记录最新的字符串
            lastNewPassword = npwLabel.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }

    func didInputConfirmNewPassword() {
        if cnpwLabel.stringValue.count > 12 {
            //字符串如果大于12个，将替换为上一个临界字符串
            cnpwLabel.stringValue = lastConfirmNewPassword
        }
        else {
            //记录最新的字符串
            lastConfirmNewPassword = cnpwLabel.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }

}
