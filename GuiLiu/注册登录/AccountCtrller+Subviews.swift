//
//  AccountCtrller+BottomView.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/12/16.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension AccountCtrller: TextFieldCustomizeProtocol,ViewDecorateProtocol {

    func setupViewForLoginDirectly() {
        let accountLabel = CMCursorField(string: "")
        directlyView.addSubview(accountLabel)
        customizeTransparentLabel(accountLabel, placeholderString: "邮件地址")
        attachUnderline(to: accountLabel)
        accountLabel.tag = 1001
        accountLabel.snp.makeConstraints({ (maker) in
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.width.equalTo(ViewMetrics.width)
            maker.top.equalToSuperview()
            maker.height.greaterThanOrEqualTo(0)
        })

        let passwordLabel = CMSecureCursorField(string: "")
        directlyView.addSubview(passwordLabel)
        customizeTransparentLabel(passwordLabel, placeholderString: "密码")
        attachUnderline(to: passwordLabel)
        passwordLabel.tag = 1002
        passwordLabel.cell?.sendsActionOnEndEditing = false
        passwordLabel.target = self
        passwordLabel.action = #selector(returnKeyAction)
        passwordLabel.snp.makeConstraints({ (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(ViewMetrics.width)
            maker.top.equalTo(accountLabel.snp.bottom).offset(15)
            maker.height.greaterThanOrEqualTo(0)
        })

        let loginButton = NSButton()
        directlyView.addSubview(loginButton)
        loginButton.image = NSImage(named: NSImage.Name("login"))
        loginButton.fixButtonBehavior()
        loginButton.target = self
        loginButton.action = #selector(loginDirectly)
        loginButton.tag = 1004
        loginButton.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(ViewMetrics.width)
            maker.top.equalTo(passwordLabel.snp.bottom).offset(25)
            maker.height.equalTo(40)
            maker.bottom.equalToSuperview()
        }

        //按Tab键可以快速切换输入焦点
        accountLabel.nextKeyView = passwordLabel
        passwordLabel.nextKeyView = loginButton
        loginButton.nextKeyView = accountLabel
    }

    func setupViewForNewcomer() {
        let accountLabel = CMCursorField(string: "")
        newcomerView.addSubview(accountLabel)
        customizeTransparentLabel(accountLabel, placeholderString: "邮件地址")
        attachUnderline(to: accountLabel)
        accountLabel.tag = 1001
        accountLabel.snp.makeConstraints({ (maker) in
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.width.equalTo(ViewMetrics.width)
            maker.top.equalToSuperview()
            maker.height.greaterThanOrEqualTo(0)
        })

        let passwordLabel = CMSecureCursorField(string: "")
        newcomerView.addSubview(passwordLabel)
        customizeTransparentLabel(passwordLabel, placeholderString: "密码")
        attachUnderline(to: passwordLabel)
        passwordLabel.tag = 1002
        passwordLabel.snp.makeConstraints({ (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(ViewMetrics.width)
            maker.top.equalTo(accountLabel.snp.bottom).offset(15)
            maker.height.greaterThanOrEqualTo(0)
        })

        let passwordComfirmLabel = CMSecureCursorField(string: "")
        newcomerView.addSubview(passwordComfirmLabel)
        customizeTransparentLabel(passwordComfirmLabel, placeholderString: "确认密码")
        attachUnderline(to: passwordComfirmLabel)
        passwordComfirmLabel.tag = 1003
        passwordComfirmLabel.cell?.sendsActionOnEndEditing = false
        passwordComfirmLabel.target = self
        passwordComfirmLabel.action = #selector(returnKeyAction)
        passwordComfirmLabel.snp.makeConstraints({ (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(ViewMetrics.width)
            maker.top.equalTo(passwordLabel.snp.bottom).offset(15)
            maker.height.greaterThanOrEqualTo(0)
        })

        let loginButton = NSButton()
        newcomerView.addSubview(loginButton)
        loginButton.image = NSImage(named: NSImage.Name("register"))
        loginButton.fixButtonBehavior()
        loginButton.tag = 1004
        loginButton.target = self
        loginButton.action = #selector(registerToLogin)
        loginButton.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(ViewMetrics.width)
            maker.top.equalTo(passwordComfirmLabel.snp.bottom).offset(25)
            maker.height.equalTo(40)
            maker.bottom.equalToSuperview()
        }

        //按Tab键可以快速切换输入焦点
        accountLabel.nextKeyView = passwordLabel
        passwordLabel.nextKeyView = passwordComfirmLabel
        passwordComfirmLabel.nextKeyView = loginButton
        loginButton.nextKeyView = accountLabel
    }

    func setupBottomView() {
        //用于选择登陆还是注册的界面
        let dict = [NSAttributedString.Key.foregroundColor: NSColor.white]

        let attrStringBot = NSAttributedString(string: "注册新账号", attributes: dict)
        botButton.attributedTitle = attrStringBot
        botButton.target = self
        botButton.action = #selector(presentNewcomerView)
        view.addSubview(botButton)
        botButton.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(ViewMetrics.width)
            maker.bottom.equalToSuperview().offset(-20)
            maker.height.greaterThanOrEqualTo(0)
        }

        let attrStringTop = NSAttributedString(string: "已有账号，直接登陆", attributes: dict)
        topButton.attributedTitle = attrStringTop
        topButton.target = self
        topButton.action = #selector(presentDirectlyView)
        view.addSubview(topButton)
        topButton.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(ViewMetrics.width)
            maker.bottom.equalTo(botButton.snp.top).offset(-20)
            maker.height.greaterThanOrEqualTo(0)
        }

        let policy = NSTextField(labelWithString: "注册即视为自动同意")
        policy.textColor = NSColor.lightGray
        policy.font = NSFont.systemFont(ofSize: 10)
        view.addSubview(policy)
        policy.snp.makeConstraints { (maker) in
            maker.left.equalTo(topButton)
            maker.width.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(topButton.snp.top).offset(-20)
            maker.height.greaterThanOrEqualTo(0)
        }

        policyBtn.image = NSImage(named: NSImage.Name("policy"))
        policyBtn.fixButtonBehavior()
        policyBtn.target = self
        policyBtn.action = #selector(openPolicy)
        view.addSubview(policyBtn)
        policyBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(policy.snp.right).offset(5)
            maker.width.greaterThanOrEqualTo(0)
            maker.centerY.equalTo(policy)
            maker.height.greaterThanOrEqualTo(0)
        }

        //登陆状态圈
        pSpin.style = .spinning
        pSpin.controlSize = .regular
        pSpin.set(tintColor: NSColor.white)
        pSpin.isDisplayedWhenStopped = false
        view.addSubview(pSpin)
        pSpin.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(policy.snp.top).offset(-15)
            maker.height.greaterThanOrEqualTo(0)
        }
    }

    @objc func presentDirectlyView() {
        if methodType == .login {return}

        //如有必要移除当前状态view，保存用户已输入信息，并更新状态
        if methodType == .register {
            saveAccountInputInfo()
            newcomerView.removeFromSuperview()
        }
        methodType = .login
        topButton.state = .on
        botButton.state = .off

        //呈现新状态view
        view.addSubview(directlyView)
        directlyView.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().offset(-30)
        }

        //尝试恢复已保存的信息
        restoreAccountInputInfo()
    }

    @objc func presentNewcomerView() {
        if methodType == .register {return}

        //如有必要移除当前状态view，保存用户已输入信息，并更新状态
        if methodType == .login {
            saveAccountInputInfo()
            directlyView.removeFromSuperview()
        }
        methodType = .register
        topButton.state = .off
        botButton.state = .on

        //呈现新状态view
        view.addSubview(newcomerView)
        newcomerView.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().offset(-30)
        }

        //尝试恢复已保存的信息
        restoreAccountInputInfo()
    }
}
