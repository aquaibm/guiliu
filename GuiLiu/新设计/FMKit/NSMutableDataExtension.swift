//
//  NSMutableDataExtension.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/7/24.
//  Copyright © 2018年 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension NSMutableData {
    func appendString(_ string: String) {
        guard let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
            return
        }
        append(data)
    }
}
