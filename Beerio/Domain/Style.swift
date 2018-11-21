//
//  Style.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 21/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import Foundation

class Style : Codable {
    var id : Int
    var name : String
    var description : String
    var categoryId : Int
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: CodingKeys.id)
        name = try container.decode(String.self, forKey: CodingKeys.name)
        description = try container.decodeIfPresent(String.self, forKey: CodingKeys.description) ?? ""
        categoryId = try container.decode(Int.self, forKey: CodingKeys.categoryId)
        
    }
    
    private enum CodingKeys : String, CodingKey {
        case id
        case name
        case description
        case categoryId
    }
}

class Styles : Codable {
    var styles: [Style]
    
    private enum CodingKeys : String, CodingKey {
        case styles = "data"
    }
}
