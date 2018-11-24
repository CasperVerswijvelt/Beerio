//
//  LocalController.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 23/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import Foundation
import RealmSwift

class LocalController {
    static let singleton : LocalController = LocalController()
    
    var beers : Results<Beer> = try! Realm().objects(Beer.self)
    
    func addBeer(beer : Beer) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(beer)
        }
    }
    
    func removeBeer(beer:Beer) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(beer)
        }
    }
    
    
}
