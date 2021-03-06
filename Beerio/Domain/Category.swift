//
//  Style.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 21/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import Foundation

struct Category : Codable{
    //Variables
    var id : Int
    var name : String
    var description : String?
    
    //CodingKeys for Codable
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
    }
}

//Multiple categories, se we can easily decode to this type from json
struct Categories : Codable {
    let categories : [Category]
    
    //CodingKeys for Codable
    private enum CodingKeys: String, CodingKey {
        case categories = "data"
    }
}
