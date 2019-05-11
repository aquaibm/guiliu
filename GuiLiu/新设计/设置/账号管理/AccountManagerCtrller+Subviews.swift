//
//  AccountManagerCtrller+Subviews.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/1/9.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit


extension AccountManagerCtrller: TextFieldCustomizeProtocol,ViewDecorateProtocol {
    func setupSubviews() {
        let container = NSView()
        view.addSubview(container)

        let mainColor = NSColor(white: 0.85, alpha: 1.0)

        //-----------------------------------------------------------------------------------
        let dotA = generateDotView()
        container.addSubview(dotA)

        let tipLabelA = NSTextField(labelWithString: "修改你的账号信息")
        tipLabelA.textColor = mainColor
        tipLabelA.font = NSFont.boldSystemFont(ofSize: 15)
        container.addSubview(tipLabelA)
        tipLabelA.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(25)
            maker.width.height.greaterThanOrEqualTo(0)
            maker.top.equalToSuperview()
        }
        dotA.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview()
            maker.centerY.equalTo(tipLabelA)
            maker.width.height.equalTo(10)
        }

        //
        let emailInfo = NSTextField(labelWithString: "邮件账号")
        emailInfo.textColor = mainColor
        container.addSubview(emailInfo)
        emailInfo.snp.makeConstraints { (maker) in
            maker.left.equalTo(tipLabelA)
            maker.width.greaterThanOrEqualTo(0)
            maker.top.equalTo(tipLabelA.snp.bottom).offset(20)
            maker.height.greaterThanOrEqualTo(0)
        }

        emailLabel.textColor = mainColor
        container.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(tipLabelA).offset(80)
            maker.width.equalTo(200)
            maker.centerY.equalTo(emailInfo)
            maker.height.greaterThanOrEqualTo(0)
        }

        //
        let nickInfo = NSTextField(labelWithString: "昵称")
        nickInfo.textColor = mainColor
        container.addSubview(nickInfo)
        nickInfo.snp.makeConstraints { (maker) in
            maker.left.equalTo(emailInfo)
            maker.width.greaterThanOrEqualTo(0)
            maker.top.equalTo(emailInfo.snp.bottom).offset(20)
            maker.height.greaterThanOrEqualTo(0)
        }

        container.addSubview(nickLabel)
        customizeTransparentLabel(nickLabel)
        attachUnderline(to: nickLabel)
        nickLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(emailLabel)
            maker.width.equalTo(200)
            maker.centerY.equalTo(nickInfo)
            maker.height.greaterThanOrEqualTo(0)
        }

        //
        let pwInfo = NSTextField(labelWithString: "现今密码")
        pwInfo.textColor = mainColor
        container.addSubview(pwInfo)
        pwInfo.snp.makeConstraints { (maker) in
            maker.left.equalTo(tipLabelA)
            maker.width.greaterThanOrEqualTo(0)
            maker.top.equalTo(nickInfo.snp.bottom).offset(20)
            maker.height.greaterThanOrEqualTo(0)
        }

        container.addSubview(pwLabel)
        customizeTransparentLabel(pwLabel,placeholderString: "不修改密码则留空",fontSize: pwInfo.font!.pointSize)
        attachUnderline(to: pwLabel)
        pwLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(emailLabel)
            maker.width.equalTo(200)
            maker.centerY.equalTo(pwInfo)
            maker.height.greaterThanOrEqualTo(0)
        }

        //
        let npwInfo = NSTextField(labelWithString: "新密码")
        npwInfo.textColor = mainColor
        container.addSubview(npwInfo)
        npwInfo.snp.makeConstraints { (maker) in
            maker.left.equalTo(tipLabelA)
            maker.width.greaterThanOrEqualTo(0)
            maker.top.equalTo(pwLabel.snp.bottom).offset(20)
            maker.height.greaterThanOrEqualTo(0)
        }

        container.addSubview(npwLabel)
        customizeTransparentLabel(npwLabel,placeholderString: "6-12位，不修改密码则留空",fontSize: npwInfo.font!.pointSize)
        attachUnderline(to: npwLabel)
        npwLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(emailLabel)
            maker.width.equalTo(200)
            maker.centerY.equalTo(npwInfo)
            maker.height.greaterThanOrEqualTo(0)
        }

        //
        let cnpwInfo = NSTextField(labelWithString: "确认新密码")
        cnpwInfo.textColor = mainColor
        container.addSubview(cnpwInfo)
        cnpwInfo.snp.makeConstraints { (maker) in
            maker.left.equalTo(tipLabelA)
            maker.width.greaterThanOrEqualTo(0)
            maker.top.equalTo(npwLabel.snp.bottom).offset(20)
            maker.height.greaterThanOrEqualTo(0)
        }

        container.addSubview(cnpwLabel)
        customizeTransparentLabel(cnpwLabel,placeholderString: "6-12位，不修改密码则留空",fontSize: cnpwInfo.font!.pointSize)
        attachUnderline(to: cnpwLabel)
        cnpwLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(emailLabel)
            maker.width.equalTo(200)
            maker.centerY.equalTo(cnpwInfo)
            maker.height.greaterThanOrEqualTo(0)
        }

        nickLabel.nextKeyView = pwLabel
        pwLabel.nextKeyView = npwLabel
        npwLabel.nextKeyView = cnpwLabel
        cnpwLabel.nextKeyView = nickLabel

        saveBtn.bezelStyle = .texturedSquare
        saveBtn.title = "保存更改"
        saveBtn.font = cnpwInfo.font
        saveBtn.target = self
        saveBtn.action = #selector(saveProfile)
        container.addSubview(saveBtn)
        saveBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(cnpwInfo)
            maker.width.equalTo(70)
            maker.top.equalTo(cnpwInfo.snp.bottom).offset(20)
            maker.height.equalTo(28)
        }

        saveSpin.controlSize = .small
        saveSpin.style = .spinning
        saveSpin.set(tintColor: NSColor.white)
        saveSpin.isDisplayedWhenStopped = false
        container.addSubview(saveSpin)
        saveSpin.snp.makeConstraints { (maker) in
            maker.left.equalTo(saveBtn.snp.right).offset(20)
            maker.width.height.greaterThanOrEqualTo(0)
            maker.centerY.equalTo(saveBtn)
        }

        //-----------------------------------------------------------------------------------
        let dotC = generateDotView()
        container.addSubview(dotC)

        let tipLabelC = NSTextField(labelWithString: "退出当前账号")
        tipLabelC.textColor = mainColor
        tipLabelC.font = NSFont.boldSystemFont(ofSize: 15)
        container.addSubview(tipLabelC)
        tipLabelC.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(25)
            maker.width.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(saveBtn.snp.bottom).offset(30)
        }
        dotC.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview()
            maker.centerY.equalTo(tipLabelC)
            maker.width.height.equalTo(10)
        }

        logoutBtn.bezelStyle = .texturedSquare
        logoutBtn.title = "退出登陆"
        logoutBtn.font = saveBtn.font
        logoutBtn.target = self
        logoutBtn.action = #selector(logout)

        container.addSubview(logoutBtn)
        logoutBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(cnpwInfo)
            maker.width.equalTo(70)
            maker.top.equalTo(tipLabelC.snp.bottom).offset(20)
            maker.height.equalTo(28)
        }

        //-----------------------------------------------------------------------------------

        container.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.right.equalTo(emailLabel)
            maker.bottom.equalTo(logoutBtn).offset(10)
        }
    }

    func generateDotView() -> NSView {
        let dotView = NSView()
        dotView.wantsLayer = true
        dotView.layer?.backgroundColor = NSColor.lightGray.cgColor
        dotView.layer?.cornerRadius = 5
        return dotView
    }
}
