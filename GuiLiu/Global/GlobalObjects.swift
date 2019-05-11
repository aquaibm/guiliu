//
//  GlobalObjects.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/6/10.
//  Copyright © 2018年 Moonlight. All rights reserved.
//

import Foundation
import AppKit

//let gServerBaseURL = URL(string: "http://0.0.0.0:8080")!
let gServerBaseURL = URL(string: "https://guiliuvapor.herokuapp.com/")!

var gUser: User?
var gAuth: String? {
    guard let user = gUser else {
        return nil
    }
    let loginString = String(format: "%@:%@", user.email, user.password)
    let loginData = loginString.data(using: String.Encoding.utf8)!
    let base64LoginString = loginData.base64EncodedString()
    return base64LoginString
}

let gRedColor: NSColor = ColorFromRGB(rgbValue: 0xFA6062)
let gDarkColor: NSColor = ColorFromRGB(rgbValue: 0x333333)
let gBlackColor: NSColor = ColorFromRGB(rgbValue: 0x3B3F45)

let gAppDelegate: AppDelegate = {return NSApp.delegate as! AppDelegate}()
