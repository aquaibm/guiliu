//
//  SettingsCtrller+BarViewActions.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/1/8.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit


extension SettingsCtrller {


    @objc func accountAction() {
        if selectedCtr != nil, selectedCtr == accountCtr {return}
        relayoutIndictorLine(to: accountBtn)
        selectedCtr?.view.removeFromSuperview()

        if accountCtr == nil {
            accountCtr = AccountManagerCtrller.init(nibName: nil, bundle: nil)
        }
        selectedCtr = accountCtr
        view.addSubview(accountCtr!.view)
        accountCtr!.view.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }

    @objc func bTopicAction() {
        if selectedCtr != nil, selectedCtr == topicCtr {return}
        relayoutIndictorLine(to: bTopicBtn)
        selectedCtr?.view.removeFromSuperview()

        if topicCtr == nil {
            topicCtr = BTopicCtrller.init(nibName: nil, bundle: nil)
        }
        selectedCtr = topicCtr
        view.addSubview(topicCtr!.view)
        topicCtr!.view.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }

    @objc func bUserAction() {
        if selectedCtr != nil, selectedCtr == userCtr {return}
        relayoutIndictorLine(to: bUserBtn)
        selectedCtr?.view.removeFromSuperview()

        if userCtr == nil {
            userCtr = BUserCtrller.init(nibName: nil, bundle: nil)
        }
        selectedCtr = userCtr
        view.addSubview(userCtr!.view)
        userCtr!.view.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }

    @objc func bHostAction() {
        if selectedCtr != nil, selectedCtr == hostCtr {return}
        relayoutIndictorLine(to: bHostBtn)
        selectedCtr?.view.removeFromSuperview()

        if hostCtr == nil {
            hostCtr = BHostCtrller.init(nibName: nil, bundle: nil)
        }
        selectedCtr = hostCtr
        view.addSubview(hostCtr!.view)
        hostCtr!.view.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }

    @objc func bLinkAction() {
        if selectedCtr != nil, selectedCtr == linkCtr {return}
        relayoutIndictorLine(to: bLinkBtn)
        selectedCtr?.view.removeFromSuperview()

        if linkCtr == nil {
            linkCtr = BLinkCtrller.init(nibName: nil, bundle: nil)
        }
        selectedCtr = linkCtr
        view.addSubview(linkCtr!.view)
        linkCtr!.view.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }

    @objc func backButtonAction() {
        gAppDelegate.dismissCurrentCtrller()
    }
}
