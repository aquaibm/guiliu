//
//  Collection+Extension.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/3/24.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation

public extension Collection {

    /// Element at the given index if it exists.
    ///
    /// - Parameter index: index of element.
    subscript(safe index: Index) -> Element? {
        // http://www.vadimbulavin.com/handling-out-of-bounds-exception/
        return indices.contains(index) ? self[index] : nil
    }
}
