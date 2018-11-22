//
//  Labels.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 22/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import Foundation

class Labels : Codable {
    var icon : URL
    var medium : URL
    var large : URL
    
    private enum CodingKeys : String, CodingKey {
        case icon
        case medium
        case large
    }
}
