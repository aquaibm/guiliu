//
//  FMFunctions.swift
//  归流
//
//  Created by Li Fumin on 2018/4/11.
//  Copyright © 2018年 Moonlight. All rights reserved.
//

import AppKit

func ColorFromRGB(rgbValue: UInt) -> NSColor {
    return NSColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                   green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                   blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                   alpha: CGFloat(1.0)
    )
}

func ColorFromRGBA(rgbValue: UInt,alpha: CGFloat) -> NSColor {
    return NSColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                   green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                   blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                   alpha: alpha
    )
}

//重复检查是否满足一定条件，满足的话执行一次指定指令
func RepeatTry(onDispatchQueue: DispatchQueue, period: Double, untilMeet: @escaping () -> (test: Bool,leftover: Any?), execute: @escaping (Any?) -> Void){
    func delayOpen(){
        let condition = untilMeet()
        if condition.test == false
        {
            onDispatchQueue.asyncAfter(deadline: DispatchTime.now() + period, execute: {
                delayOpen()
            })
        }
        else
        {
            execute(condition.leftover)
        }
    }
    delayOpen()
}

func SwatchImageFromColor(_ color: NSColor, size: NSSize) -> NSImage {
    let image = NSImage(size: size)
    image.lockFocus()
    color.drawSwatch(in: NSMakeRect(0, 0, size.width, size.height))
    image.unlockFocus()
    return image
}

func LinkAttributedString(title:String,for url: URL) -> NSMutableAttributedString {
    // initially set viewable text
    let attrString = NSMutableAttributedString(string: title)
    let range = NSRange(location: 0, length: attrString.length)
    attrString.beginEditing()
    // stack URL
    attrString.addAttribute(.link, value: url.absoluteString, range: range)
    // stack text color
    attrString.addAttribute(.foregroundColor,value: ColorFromRGB(rgbValue: 0x0096CF), range: range)
    attrString.endEditing()
    return attrString
}

func LocalToUTC(date:String, fromFormat: String, toFormat: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = fromFormat
    dateFormatter.calendar = NSCalendar.current
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.amSymbol = "上午"
    dateFormatter.pmSymbol = "下午"
    
    let dt = dateFormatter.date(from: date)
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    dateFormatter.dateFormat = toFormat
    
    return dateFormatter.string(from: dt!)
}

func UTCToLocal(date:String, fromFormat: String, toFormat: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = fromFormat
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    dateFormatter.amSymbol = "上午"
    dateFormatter.pmSymbol = "下午"
    
    let dt = dateFormatter.date(from: date)
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = toFormat
    
    return dateFormatter.string(from: dt!)
}

func GetTrimmedTitle(from: String?) -> String {
    //截断非标题部分
    guard let trueFrom = from else {
        return ""
    }
    if let range = trueFrom.rangeOfCharacter(from: CharacterSet(charactersIn: "_"))
    {
        return String(trueFrom[..<range.lowerBound]).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    else
    {
        return trueFrom.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
