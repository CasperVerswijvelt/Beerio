//
//  Glass.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 22/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Glass: Object, Codable {
    @objc dynamic var id : Int=0
    @objc dynamic var name : String=""
    
    private enum CodingKeys : String, CodingKey {
        case id
        case name
    }
    
    //Realm initialisers
    convenience init(id: Int, name : String) {
        self.init()
        self.id = id
        self.name = name
    }
    required init() {
        super.init()
    }
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}
