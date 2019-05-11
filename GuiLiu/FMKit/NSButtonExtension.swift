//
//  NSButtonExtension.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/8/1.
//  Copyright © 2018年 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension NSButton {
    
  /*momentary push in , 两种状态图片的按钮定制
     -[NSButtonCell setButtonType:] is (mostly) a cover for certain combinations
     of -[NSButtonCell setHighlightsBy:] and -[NSButtonCell setShowsStateBy:].
     
     For a button, highlighted is synonymous with "pressed".  setHighlightsBy:
     controls how a button draws to communicate that it is pressed.  It takes an
     NSCellMask describing the look.
     
     showsStateBy: describes how a button should draw to show that it's "on".
     _All_ buttons change from on to off and back when clicked, it's just that
     many do not show it.  This is also described with an NSCellMask.
     
     NSCellMask is a combination of NSContentsCellMask, NSPushInCellMask,
     NSChangeGrayCellMask, and NSChangeBackgroundCellMask.  0 is also a
     possibility, which would mean "do not draw differently".
     
     NSContentsCellMask means "use alternate contents", i.e. -[NSButtonCell
     alternateImage] and -[NSButtonCell alternateTitle].
     
     NSPushInCellMask means "look pushed in".
     
     NSChangeGrayCellMask and NSChangeBackgroundCellMask are rather historical
     names (the first comes from the NeXT's four color display - it refers to
     swapping one of the two gray colors with the other one!).  They basically
     mean, uh, draw the bezel differently in some fashion.
     
     Anyway, NSMomentaryLightButton sets highlightsBy to
     NSChangeGrayCellMask|NSChangeBackgroundCellMask
     and showsStateBy to 0.
     
     NSMomentaryPushInButton sets highlightsBy to NSPushInCellMask and
     showsStateBy to 0.
     
     NSPushOnPushOffButton sets highlightsBy to NSPushInCellMask |
     NSChangeGrayCellMask|NSChangeBackgroundCellMask and showsStateBy to
     NSChangeGrayCellMask|NSChangeBackgroundCellMask.
     
     NSOnOffButton sets highlightsBy to
     NSChangeGrayCellMask|NSChangeBackgroundCellMask
     and showsStateBy to NSChangeGrayCellMask|NSChangeBackgroundCellMask.
     
     I find direct use of showsStateBy and highlightsBy to mostly make more sense
     than setButtonType. */
    
    func fixButtonBehavior() {
        isBordered = false
        let theCell = cell as! NSButtonCell
        theCell.highlightsBy = .contentsCellMask
    }
}
