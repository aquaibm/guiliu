//
//  PostArticleCtrller+PreviewLogic.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/11/24.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit
import Kanna


extension LinkPostCtrller {
    func getURLFromPasteboard() {
        guard let obj = NSPasteboard.general.readObjects(forClasses: [NSString.self,NSAttributedString.self], options: nil)?.first else {
            return
        }

        var string: String?
        if let str = obj as? String {
            string = str
        }
        else if let attStr = obj as? NSAttributedString {
            string = attStr.string
        }

        guard let input = string else {
            return
        }

        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            debugPrint("Fail to initialize detector.")
            return
        }
        guard let firstMatch = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.count)).first else {
            return
        }

        guard let range = Range(firstMatch.range, in: input) else {
            debugPrint("Wrong range.")
            return
        }
        let urlStr = input[range]
        var finalStr = String(urlStr)

        //加上http字段
        if finalStr.lowercased().hasPrefix("http") == false {
            finalStr = "http://" + finalStr
        }

        //检查粘贴板对应的网址是否已经被自动填充过了
        guard pURLHistories.contains(finalStr) == false else {
            debugPrint("该网址已经被自动填充过了")
            return
        }
        pURLHistories.append(finalStr)

        addressInputField.stringValue = finalStr
        NotificationCenter.default.post(name: NSControl.textDidChangeNotification, object: addressInputField)
    }

    func loadPreviewData() {
        //更新时间戳
        let newMark = Date()
        self.pDateMark = newMark

        func reset() {
            pCurrentURL = nil
            hostLabel.stringValue = ""
            titleLabel.stringValue = ""
            summaryLabel.stringValue = ""
        }

        let input = addressInputField.stringValue
        if input.isEmpty {
            self.submitButton.isEnabled = false
            self.tipLabel.stringValue = ""
            reset()
        }
        else {
            //延迟执行，避免密集执行
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                guard newMark == self.pDateMark else {
                    return
                }

                reset()

                guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
                    debugPrint("Fail to initialize detector.")
                    return
                }
                guard let firstMatch = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.count)).first else {
                    self.submitButton.isEnabled = false
                    self.tipLabel.stringValue = "没有发现有效的网址。"
                    return
                }
                self.submitButton.isEnabled = true

                guard let range = Range(firstMatch.range, in: input) else {
                    debugPrint("Wrong range.")
                    return
                }
                let urlStr = input[range]
                var str = String(urlStr)

                //加上http字段
                if str.lowercased().hasPrefix("http") == false {
                    str = "http://" + str
                }

                guard let url = URL(string: str) else {
                    debugPrint("Fail to initialize url.")
                    return
                }
                self.pCurrentURL = url

                //开始加载动画
                self.spinIndicator.startAnimation(nil)

                //Host
                self.hostLabel.stringValue = url.host ?? ""

                //后台优先执行
                DispatchQueue.global(qos: .userInitiated).async {
                    if let source = try? Data(contentsOf: url),let doc = try? HTML(html: source, encoding: .utf8) {
                        //下载整页源码，用kanna解析后获取所需信息
                        self.updatePreview(with: doc, dateMark: newMark)
                    }

                    //停止动画
                    DispatchQueue.main.async {
                        self.spinIndicator.stopAnimation(nil)
                    }
                }
            })
        }
    }

    func updatePreview(with doc: HTMLDocument, dateMark: Date) {
        //如果对应的不是最新的预览，就没必要继续了
        guard pDateMark == pDateMark else {
            return
        }
        OperationQueue.main.addOperation {
            //发送按钮处理
            self.submitButton.isEnabled = false
            defer {
                if self.titleLabel.stringValue.isEmpty == false {
                    self.submitButton.isEnabled = true
                }
            }

            //标题
            if let node = doc.xpath("//title").first, let title = node.text {
                self.titleLabel.stringValue = GetTrimmedTitle(from: title)
            }
            else if let node = doc.xpath("//meta[@property='og:title']").first, let title = node.text {
                self.titleLabel.stringValue = GetTrimmedTitle(from: title)
            }
            else if let node = doc.xpath("//meta[@property='twitter:title']").first, let title = node.text {
                self.titleLabel.stringValue = GetTrimmedTitle(from: title)
            }

            //描述
            if let node = doc.xpath("//meta[@name='Description']").first, let content = node.xpath("@content").first, let descr = content.text {
                self.summaryLabel.stringValue = descr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            }
            else if let node = doc.xpath("//meta[@name='description']").first, let content = node.xpath("@content").first, let descr = content.text {
                self.summaryLabel.stringValue = descr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            }
            else if let node = doc.xpath("//meta[@property='og:description']").first, let content = node.xpath("@content").first, let descr = content.text {
                self.summaryLabel.stringValue = descr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            }
            else if let node = doc.xpath("//meta[@property='twitter:description']").first, let content = node.xpath("@content").first, let descr = content.text {
                self.summaryLabel.stringValue = descr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            }
            else {
                func fetchDescription(with nodes: XPathObject) {
                    //尝试提取字符数超过count个的句子
                    func getNodeWithCountLimitation(_ count: Int) -> Kanna.XMLElement? {
                        let theNode = nodes.first(where: { (element) -> Bool in
                            guard let text = element.text else {
                                return false
                            }
                            return text.count > count
                        })
                        return theNode
                    }

                    if let twtStr = getNodeWithCountLimitation(20)?.text {
                        self.summaryLabel.stringValue = twtStr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    }
                    else if let tenStr = getNodeWithCountLimitation(10)?.text {
                        self.summaryLabel.stringValue = tenStr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    }
                    else if let fiveStr = getNodeWithCountLimitation(5)?.text {
                        self.summaryLabel.stringValue = fiveStr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    }
                }

                let nodes = doc.xpath("//div[@id='js_content']//p")
                if nodes.count > 0 {
                    fetchDescription(with: nodes)
                    return
                }

                let wbNodes = doc.xpath("//div[@node-type='contentBody']//p")
                if wbNodes.count > 0 {
                    fetchDescription(with: wbNodes)
                    return
                }

                let otherNodes = doc.xpath("//p")
                if otherNodes.count > 0 {
                    fetchDescription(with: otherNodes)
                    return
                }
            }
        }
    }
}
