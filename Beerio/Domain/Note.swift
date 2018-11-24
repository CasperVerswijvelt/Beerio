//
//  Note.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 24/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Note : Object {
    @objc dynamic var date : Date = Date()
    @objc dynamic var text : String = ""
    
    convenience init(text : String) {
        self.init()
        self.text = text;
    }
    
    //Realm initialisers
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
