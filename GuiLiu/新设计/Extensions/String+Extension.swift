//
//  FMExtension.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/6/8.
//  Copyright © 2018年 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension String {
    func emailValidate() -> String? {
        let trimmedText = self.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return nil
        }
        
        let range = NSMakeRange(0, NSString(string: trimmedText).length)
        let allMatches = dataDetector.matches(in: trimmedText,options: [],range: range)
        if allMatches.count == 1,allMatches.first?.url?.absoluteString.contains("mailto:") == true
        {
            return trimmedText
        }
        return nil
    }
    
    func passwordValidate() -> String? {
        let trimmedText = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if 6...12 ~=  trimmedText.count {
            return trimmedText
        }
        return nil
    }

    func nicknameValidate() -> Bool {
        if 1...12 ~= self.count {
            return true
        }
        else {
            return false
        }
    }
}
