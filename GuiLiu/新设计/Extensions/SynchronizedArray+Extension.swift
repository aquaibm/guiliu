//
//  SynchronizedArray+Extension.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/3/24.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation

extension SynchronizedArray {
    func filterDuplicates(includeElement: @escaping (_ lhs: Element, _ rhs: Element) -> Bool) -> [Element] {
        var results = [Element]()
        forEach { (element) in
            let existingElements = results.filter {
                return includeElement(element, $0)
            }

            if existingElements.count == 0 {
                results.append(element)
            }
        }
        return results
    }
}
