//
//  TopicCollectionProtocol.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/12/7.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit

protocol TopicCollectionProtocol: AnyObject {
    var searchView: CMSearchView {get}

    var pScrollView: NSScrollView! {get set}
    var pCollectionView: NSCollectionView! {get set}

    var progressSpin: NSProgressIndicator {get}
    var leftButton: NSButton {get}
    var rightButton: NSButton {get}
    var tipLabel: NSTextField {get}
}


extension TopicCollectionProtocol where Self: NSViewController & NSCollectionViewDelegate & NSCollectionViewDataSource & ViewDecorateProtocol & TextFieldCustomizeProtocol & CMSearchDelegate {
    func setupCollectionView() {
        let offset = 5
        //前一页
        let leftView = NSView()
        view.addSubview(leftView)

        leftButton.image = NSImage(named: NSImage.Name("leftArrow"))
        leftButton.alternateImage = NSImage(named: NSImage.Name("leftArrowOn"))
        leftButton.fixButtonBehavior()
        leftButton.isHidden = true
        leftButton.imageScaling = .scaleNone
        leftView.addSubview(leftButton)
        leftButton.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(offset)
            maker.width.greaterThanOrEqualTo(0)
            maker.top.bottom.equalToSuperview()
        }

        leftView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview()
            maker.right.equalTo(leftButton).offset(offset)
            maker.top.bottom.equalToSuperview()
        }

        //后一业
        let rightView = NSView()
        view.addSubview(rightView)

        rightButton.image = NSImage(named: NSImage.Name("rightArrow"))
        rightButton.alternateImage = NSImage(named: NSImage.Name("rightArrowOn"))
        rightButton.fixButtonBehavior()
        rightButton.isHidden = true
        rightButton.imageScaling = .scaleNone
        rightView.addSubview(rightButton)
        rightButton.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(-offset)
            maker.width.greaterThanOrEqualTo(0)
            maker.top.bottom.equalToSuperview()
        }

        rightView.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview()
            maker.left.equalTo(rightButton).offset(-offset)
            maker.top.bottom.equalToSuperview()
        }

        //searchField
        searchView.delegate = self
        view.addSubview(searchView)
        searchView.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().offset(15)
            maker.height.greaterThanOrEqualTo(0)
        }

        //CollectionView
        pScrollView.snp.makeConstraints { (maker) in
            maker.left.equalTo(leftView.snp.right)
            maker.right.equalTo(rightView.snp.left)
            maker.top.equalToSuperview().offset(50)
            maker.bottom.equalToSuperview()
        }

        pScrollView.backgroundColor = NSColor.clear

        let layout = NSCollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        pCollectionView.collectionViewLayout = layout

        pCollectionView.backgroundColors = [NSColor.clear]
        pCollectionView.dataSource = self
        pCollectionView.delegate = self
        pCollectionView.isSelectable = true

        //加载标志
        progressSpin.style = .spinning
        progressSpin.controlSize = .regular
        progressSpin.set(tintColor: NSColor.white)
        progressSpin.isDisplayedWhenStopped = false
        view.addSubview(progressSpin)
        progressSpin.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.width.height.greaterThanOrEqualTo(0)
        }

        //翻页提示
        tipLabel.font = NSFont.systemFont(ofSize: 14)
        tipLabel.textColor = NSColor.lightGray
        view.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalToSuperview().offset(-30)
        }
    }
}
