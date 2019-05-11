//
//  Subviews.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/2/9.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit


extension TopicEditCtrller: TopicItemViewLayoutProtocol,TextFieldCustomizeProtocol,ViewDecorateProtocol {
    func setupSubViews() {
        //功能提示
        let titleTipLabel = NSTextField(labelWithString: "编辑主题")
        titleTipLabel.font = NSFont.boldSystemFont(ofSize: 18)
        titleTipLabel.textColor = NSColor.white
        view.addSubview(titleTipLabel)
        titleTipLabel.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(20)
            maker.height.greaterThanOrEqualTo(0)
            maker.centerX.equalToSuperview()
            maker.width.greaterThanOrEqualTo(0)
        }

        let desTipLabel = NSTextField(labelWithString: "仅能编辑自己创建主题的描述和图片")
        desTipLabel.textColor = NSColor.gray
        view.addSubview(desTipLabel)
        desTipLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleTipLabel.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
            maker.centerX.equalToSuperview()
            maker.width.greaterThanOrEqualTo(0)
        }

        //功能区置中容器
        view.addSubview(anchorView)

        let previewTipLabel = NSTextField(labelWithString: "效果预览")
        previewTipLabel.textColor = NSColor.gray
        anchorView.addSubview(previewTipLabel)
        previewTipLabel.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(10)
            maker.width.greaterThanOrEqualTo(0)
            maker.top.equalToSuperview().offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }

        let previewView = NSView()
        anchorView.addSubview(previewView)
        previewView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(10)
            maker.width.equalTo(240)
            maker.top.equalTo(previewTipLabel.snp.bottom).offset(20)
            maker.height.equalTo(135)
        }
        layoutTopicView(on: previewView)

        anchorView.addSubview(desInputLabel)
        customizeTransparentLabel(desInputLabel, placeholderString: "主题的描述")
        attachUnderline(to: desInputLabel)
        desInputLabel.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(15)
            maker.right.equalToSuperview().offset(-15)
            maker.top.equalTo(previewView.snp.bottom).offset(40)
            maker.height.greaterThanOrEqualTo(0)
        }

        anchorView.addSubview(imagePickerButton)
        imagePickerButton.image = NSImage(named: NSImage.Name("ImagePicker"))
        imagePickerButton.alternateImage = NSImage(named: NSImage.Name("ImagePickerOn"))
        imagePickerButton.fixButtonBehavior()
        imagePickerButton.target = self
        imagePickerButton.action = #selector(imagePickerAction)
        imagePickerButton.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(15)
            maker.width.greaterThanOrEqualTo(0)
            maker.top.equalTo(desInputLabel.snp.bottom).offset(20)
            maker.height.greaterThanOrEqualTo(0)
        }

        anchorView.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.right.equalTo(previewView).offset(10)
            maker.bottom.equalTo(imagePickerButton).offset(15)
        }
    }
}
