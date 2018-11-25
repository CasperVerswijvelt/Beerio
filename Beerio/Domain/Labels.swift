//
//  Labels.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 22/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Labels :  Object, Codable {
    var icon : URL?{
        set {
            self.iconString = newValue?.absoluteString
        }
        get {
            return URL(string: iconString ?? "")
        }
        
    }
    var medium : URL?
    var large : URL? {
        set {
            self.largeString = newValue?.absoluteString
        }
        get {
            return URL(string: largeString ?? "")
        }
    }
    
    @objc dynamic var largeString : String?
    @objc dynamic var iconString : String?
    
    //Realm initialisers
    convenience init(icon : URL, medium : URL, large:URL) {
        self.init()
        self.icon = icon
        self.medium = medium
        self.large = large
    }
    
    private enum CodingKeys : String, CodingKey {
        case iconString = "icon"
        case medium
        case largeString = "large"
    }
}
