//
//  NSImageExtension.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/7/23.
//  Copyright © 2018年 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension NSImage {
    
    func resize(to newSize: NSSize) -> NSImage?{
        let oriSize = self.size
        if newSize.width >= oriSize.width {
            return self
        }
        
        if self.isValid == false {
            return nil
        }
        
        let representation = NSBitmapImageRep(bitmapDataPlanes: nil,
                                              pixelsWide: Int(newSize.width),
                                              pixelsHigh: Int(newSize.height),
                                              bitsPerSample: 8,
                                              samplesPerPixel: 4,
                                              hasAlpha: true,
                                              isPlanar: false,
                                              colorSpaceName: .calibratedRGB,
                                              bytesPerRow: 0,
                                              bitsPerPixel: 0)
        representation?.size = newSize

        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext.init(bitmapImageRep: representation!)
        self.draw(in: NSRect(x: 0, y: 0, width: newSize.width, height: newSize.height), from: NSZeroRect, operation: .copy, fraction: 1.0)
        NSGraphicsContext.restoreGraphicsState()
        
        let newImage = NSImage(size: newSize)
        newImage.addRepresentation(representation!)
        
        return newImage
    }
}
