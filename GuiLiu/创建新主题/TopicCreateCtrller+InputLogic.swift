//
//  CreateTopicCtrller+InputLogic.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/12/17.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension TopicCreateCtrller {
    func didInputTitle() {
        lengthHelperLabel.stringValue = titleInputLabel.stringValue
        lengthHelperLabel.sizeToFit()
        if lengthHelperLabel.bounds.width >= 158.0 {
            //字符串如果大于一定长度，将替换为上一个临界字符串
            titleInputLabel.stringValue = lastTitleString
        }
        else {
            //记录最新的字符串
            lastTitleString = titleInputLabel.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        titleLabel.stringValue = lastTitleString
        updateSubmitButtonState()
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
        updateSubmitButtonState()
    }

    @objc func imagePickerAction() {
        if let imaUrl = NSOpenPanel().selectUrl,let image = NSImage(contentsOf: imaUrl) {
            imageURL = imaUrl
            imageV.layer?.contents = image
        }
    }

    func updateSubmitButtonState() {
        if titleLabel.stringValue.isEmpty == false, desLabel.stringValue.isEmpty == false {
            submitButton.isEnabled = true
        }
        else {
            submitButton.isEnabled = false
        }
    }
}
