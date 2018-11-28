//
//  Style.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 21/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import Foundation

class Style : Decodable {
    //Variables
    var id : Int
    var name : String
    var description : String
    var categoryId : Int
    
    //Decodable Initializer
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: CodingKeys.id)
        name = try container.decode(String.self, forKey: CodingKeys.name)
        description = try container.decodeIfPresent(String.self, forKey: CodingKeys.description) ?? ""
        categoryId = try container.decode(Int.self, forKey: CodingKeys.categoryId)
        
    }
    
    //CodingKeys for Decodable
    private enum CodingKeys : String, CodingKey {
        case id
        case name
        case description
        case categoryId
    }
}

//Styles, multiple of style, to decode to from json
class Styles : Decodable {
    var styles: [Style]
    
    //CodingKeys for Decodable
    private enum CodingKeys : String, CodingKey {
        case styles = "data"
    }
}
