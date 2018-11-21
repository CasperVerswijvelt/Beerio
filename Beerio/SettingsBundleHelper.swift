//
//  SettingsBundleHelper.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 21/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import Foundation
class SettingsBundleHelper {
    struct SettingsBundleKeys {
        static let API_KEY = "API_KEY"
    }
    
    var API_KEY : String? {
        get {
            if let string = UserDefaults.standard.string(forKey: SettingsBundleKeys.API_KEY) {
                if string.count == 0 {
                    return nil
                } else {
                    return string
                }
            }
            return nil
            
        }
    }
    
}
