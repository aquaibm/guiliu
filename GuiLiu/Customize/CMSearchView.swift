//
//  CMSearchView.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/12/30.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit

class CMSearchView: NSView,TextFieldCustomizeProtocol {

    fileprivate let pNotiObserverManager = FMNotificationManager()

    let searchButton = NSButton()
    let searchField = CMUnselectCursorField()
    let clearButton = NSButton()

    weak var delegate: CMSearchDelegate?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        searchButton.image = NSImage(named: NSImage.Name("Search"))
        searchButton.fixButtonBehavior()
        searchButton.target = self
        searchButton.action = #selector(searchAction)
        addSubview(searchButton)
        searchButton.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview()
            maker.width.greaterThanOrEqualTo(0)
            maker.centerY.equalToSuperview()
            maker.height.greaterThanOrEqualTo(0)
        }

        clearButton.image = NSImage(named: NSImage.Name("Clean"))
        clearButton.fixButtonBehavior()
        clearButton.target = self
        clearButton.action = #selector(clearAction)
        clearButton.isHidden = true
        addSubview(clearButton)
        clearButton.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview()
            maker.width.greaterThanOrEqualTo(0)
            maker.centerY.equalToSuperview()
            maker.height.greaterThanOrEqualTo(0)
        }

        customizeTransparentLabel(searchField, placeholderString: "Search")
        searchField.cell?.sendsActionOnEndEditing = false
        searchField.target = self
        searchField.action = #selector(searchAction)
        addSubview(searchField)
        searchField.snp.makeConstraints { (maker) in
            maker.left.equalTo(searchButton.snp.right).offset(10)
            maker.width.equalTo(80)
            maker.right.equalTo(clearButton.snp.left).offset(-10)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.bottom.equalToSuperview()
        }

        monitorNotifications()
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var searchString: String {
        get {
            return searchField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        set {
            searchField.stringValue = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }

    func monitorNotifications() {
        pNotiObserverManager.addObserver(notificationName: NSControl.textDidChangeNotification, fromObject: searchField, queue: OperationQueue.main) {[unowned self] (noti) in
            //根据需要显示异常清除按钮
            self.clearButton.isHidden = self.searchField.stringValue.isEmpty
        }
    }
}


extension CMSearchView {
    @objc func searchAction() {
        delegate?.search()
    }

    @objc func clearAction() {
        searchField.stringValue = ""
        //不知为何上面代码不会触发textDidChangeNotification， 所以要特别处理
        clearButton.isHidden = true

        //清除也要激发重新搜索
        delegate?.search()
    }
}


protocol CMSearchDelegate: AnyObject {
    func search()
}
