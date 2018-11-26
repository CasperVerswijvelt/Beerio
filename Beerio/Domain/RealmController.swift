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

class RealmController {
    static let singleton : RealmController = RealmController()
    
    var beers : Results<Beer> = try! Realm().objects(Beer.self).sorted(byKeyPath: "dateAdded", ascending: true)
    var tableView : UITableView?
    
    func addBeer(beer : Beer, shouldUpdateTable: Bool,completion: @escaping (Error?) -> Void) {
        do {
            let realm = try Realm()
            try realm.write {
                beer.dateAdded = Date()
                realm.add(beer)
            }
            self.updateResultsList()
            self.updateTable(shouldUpdateTable: shouldUpdateTable)
        } catch let error as NSError {
            completion(error)
            return
        }
        completion(nil)
        
    }
    
    func removeBeer(beer:Beer, shouldUpdateTable: Bool,completion: @escaping (Error?) -> Void)  {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(beer)
                updateTable(shouldUpdateTable: shouldUpdateTable)
            }
            updateResultsList()
        } catch let error as NSError {
            completion(error)
            return
        }
        completion(nil)
        
        
    }
    
    func addNoteToBeer(beer:Beer,text:String,completion: @escaping (Error?) -> Void) {
        do {
            try Realm().write {
                beer.notes.append(Note(text: text))
            }
        } catch let error as NSError {
            completion(error)
            return
        }
        completion(nil)
    }
    
    func removeNoteFromBeer(beer:Beer,index:Int, completion: @escaping (Error?) -> Void) {
        do {
            try Realm().write {
                beer.notes.remove(at: index)
            }
        } catch let error as NSError {
            completion(error)
            return
        }
        completion(nil)
    }
    
    func updateResultsList() {
        beers = try! Realm().objects(Beer.self).sorted(byKeyPath: "dateAdded", ascending: true)
    }
    
    func hasBeerAlreadySaved(beer : Beer) -> Bool{
        if let _ = beers.firstIndex(where: {
            $0 == beer
        }) {
            return true
        }
        return false
    }
    
    
    func setTableViewToUpdate(_ tableView : UITableView) {
        self.tableView = tableView
    }
    
    func updateTable(shouldUpdateTable : Bool) {
        if let tableView = tableView, shouldUpdateTable {
            tableView.reloadData()
        }
    }
    
    
}
