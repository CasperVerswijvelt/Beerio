//
//  Glass.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 22/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import Foundation

class Glass: Codable {
    var id : Int
    var name : String
    
    private enum CodingKeys : String, CodingKey {
        case id
        case name
    }
}
