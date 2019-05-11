//
//  TopicsContainerCtrller+BarViewSelector.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/3/5.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension TopicsContainerCtrller {
    @objc func presentPubCtrller() {
        if selectedTab == .public {return}

        //BarView部分
        relayoutIndictorLine(to: publicButton)

        //Content部分
        selectedCtr?.view.isHidden = true

        if publicCtr == nil {
            publicCtr = PubCollectionCtrller.init(nibName: nil, bundle: nil)
            view.addSubview(publicCtr!.view)
            publicCtr!.view.snp.makeConstraints { (maker) in
                maker.edges.equalToSuperview()
            }
        }

        selectedTab = .public
        selectedCtr = publicCtr
        selectedCtr?.view.isHidden = false
    }

    @objc func presentFavCtrller() {
        if selectedTab == .favorite {return}

        //BarView部分
        relayoutIndictorLine(to: favoriteButton)

        //Content部分
        selectedCtr?.view.isHidden = true

        if favoriteCtr == nil {
            favoriteCtr = FavCollectionCtrller.init(nibName: nil, bundle: nil)
            view.addSubview(favoriteCtr!.view)
            favoriteCtr!.view.snp.makeConstraints { (maker) in
                maker.edges.equalToSuperview()
            }
        }

        selectedTab = .favorite
        selectedCtr = favoriteCtr
        selectedCtr?.view.isHidden = false
    }

    @objc func presentCreateTopicCtrller() {
        gAppDelegate.presentViewCtrller(TopicCreateCtrller.init(nibName: nil, bundle: nil))
    }

    @objc func presentSettingsCtrller() {
        gAppDelegate.presentViewCtrller(SettingsCtrller.init(nibName: nil, bundle: nil))
    }
}
