//
//  EditTopicCtrller+InputLogic.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/2/9.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension TopicEditCtrller {
    func updateInfo(with tp: Topic) {
        topic = tp
        titleLabel.stringValue = tp.name
        desLabel.stringValue = tp.description ?? ""
        desInputLabel.stringValue = tp.description ?? ""

        if let avatar = tp.avatar {
            let image = NSImage(data: avatar)
            self.imageV.layer?.contents = image
        }
        else {
            self.imageV.layer?.contents = nil
        }
    }

    func didInputDescription() {
        lengthHelperLabel.stringValue = desInputLabel.stringValue
        lengthHelperLabel.sizeToFit()
        if lengthHelperLabel.bounds.width >= 210.0 {
            //字符串如果大于一定长度，将替换为上一个临界字符串
            desInputLabel.stringValue = lastDesString
        }
        else {
            //记录最新的字符串
            lastDesString = desInputLabel.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        desLabel.stringValue = lastDesString
        topic?.description = lastDesString
        updateSubmitButtonState()
    }

    @objc func imagePickerAction() {
        if let imaUrl = NSOpenPanel().selectUrl,let image = NSImage(contentsOf: imaUrl) {
            imageURL = imaUrl
            imageV.layer?.contents = image

            topic?.avatar = image.compressedJPEGRepresentation
        }
        updateSubmitButtonState()
    }

    func updateSubmitButtonState() {
        if desLabel.stringValue.isEmpty == false {
            submitButton.isEnabled = true
        }
        else {
            submitButton.isEnabled = false
        }
    }
}
