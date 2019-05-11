//
//  FMNSOpenPanelExtension.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/7/23.
//  Copyright © 2018年 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension NSOpenPanel {
    var selectUrl: URL? {
        title = "选取单个图片"
        allowsMultipleSelection = false
        canChooseDirectories = false
        canChooseFiles = true
        canCreateDirectories = false
        allowedFileTypes = ["jpg","jpeg","gif","tiff","png"]
        return runModal() == .OK ? urls.first : nil
    }
    var selectUrls: [URL]? {
        title = "选取多个图片"
        allowsMultipleSelection = true
        canChooseDirectories = false
        canChooseFiles = true
        canCreateDirectories = false
        allowedFileTypes = ["jpg","jpeg","gif","tiff","png"]
        return runModal() == .OK ? urls : nil
    }
}
