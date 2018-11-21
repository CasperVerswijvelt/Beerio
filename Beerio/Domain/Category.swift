//
//  Style.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 21/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import Foundation

struct Category : Codable{
    
    var id : Int
    var name : String
    var description : String?
    
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
    }
    
}

struct Categories : Codable {
    let categories : [Category]
    
    private enum CodingKeys: String, CodingKey {
        case categories = "data"
    }
}
