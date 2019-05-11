//
//  NSImage+Extension.swift
//  GuiLiu
//
//  Created by Li Fumin on 2019/2/9.
//  Copyright © 2019 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension NSImage {

    private func compressedJPEG(with factor: Double) -> Data? {
        guard let tiff = tiffRepresentation else { return nil }
        guard let imageRep = NSBitmapImageRep(data: tiff) else { return nil }

        let options: [NSBitmapImageRep.PropertyKey: Any] = [
            .compressionFactor: factor
        ]

        return imageRep.representation(using: .jpeg, properties: options)
    }

    var compressedJPEGRepresentation: Data? {
        return compressedJPEG(with: 0.35)
    }

}
