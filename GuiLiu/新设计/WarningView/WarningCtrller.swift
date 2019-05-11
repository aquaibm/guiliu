//
//  WarningCtrller.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/9/3.
//  Copyright © 2018年 Moonlight. All rights reserved.
//

import Foundation
import AppKit

class WarningCtrller: NSViewController,NSTableViewDelegate,NSTableViewDataSource {
    
    var pContainerView: NSView?
    @IBOutlet var pTableView: NSTableView!
    fileprivate var pMessageArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pTableView.register(NSNib(nibNamed: NSNib.Name("WarningCellView"), bundle: nil), forIdentifier:  NSUserInterfaceItemIdentifier(rawValue: "WarningCellView"))
        self.pTableView.delegate = self
        self.pTableView.dataSource = self
        self.pTableView.backgroundColor = ColorFromRGB(rgbValue: 0xEFA955)
        self.pTableView.selectionHighlightStyle = .none
    }
    
    
    func appendMessage(_ text: String) {
        OperationQueue.main.addOperation {
            self.pMessageArray.append(text)
            
            func layoutWarningView() {
                let titleBar = gAppDelegate.titlebar
                self.view.snp.makeConstraints({ (maker) in
                    maker.left.right.equalToSuperview()
                    maker.top.equalTo(titleBar.snp.bottom)
                    maker.height.equalTo(30)
                })
            }
            
            //移到最前面
            if let sView = self.view.superview {
                if sView.subviews.last != self.view {
                    self.view.removeFromSuperview()
                    sView.addSubview(self.view)
                    layoutWarningView()
                }
            }
            else {
                self.pContainerView?.addSubview(self.view)
                layoutWarningView()
            }
            

            
            //滚动到底部显示最新信息
            let lastIndex = self.pMessageArray.endIndex - 1
            self.pTableView.noteNumberOfRowsChanged()
            self.pTableView.reloadData(forRowIndexes: IndexSet.init(integer: lastIndex), columnIndexes: IndexSet.init(integer: 0))
            self.pTableView.scrollRowToVisible(lastIndex)
            
            //稍后删除对应条目
            Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
                if let index = self.pMessageArray.index(of: text) {
                    self.pMessageArray.remove(at: index)
                    self.pTableView.removeRows(at: IndexSet.init(integer: index), withAnimation: .effectFade)
                }
                
                //最后一条？隐藏
                if self.pMessageArray.count == 0,let _ = self.view.superview {
                    self.view.removeFromSuperview()
                }
            }
        }
    }
}




extension WarningCtrller {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return pMessageArray.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init("WarningCellView"), owner: nil) as! WarningCellView
        cellView.pMessageText = pMessageArray[row]
        return cellView
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30
    }
}
