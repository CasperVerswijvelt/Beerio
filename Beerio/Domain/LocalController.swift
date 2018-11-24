//
//  LocalController.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 23/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class LocalController {
    static let singleton : LocalController = LocalController()
    
    var beers : Results<Beer> = try! Realm().objects(Beer.self)
    var tableView : UITableView?
    
    func addBeer(beer : Beer) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(beer)
        }
        updateTable()
    }
    
    func removeBeer(beer:Beer) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(beer)
        }
        updateTable()
    }
    
    func setTableViewToUpdate(_ tableView : UITableView) {
        self.tableView = tableView
    }
    
    func updateTable() {
        if let tableView = tableView {
            tableView.reloadData()
        }
    }
    
    
}
