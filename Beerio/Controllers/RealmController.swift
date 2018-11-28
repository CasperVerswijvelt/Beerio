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


//This class controls all changes within the realm
class RealmController {
    //Our singleton
    static let singleton : RealmController = RealmController()
    
    //Initially reading all beers in the realm, and sort them by dateAdded
    var beers : Results<Beer> = try! Realm().objects(Beer.self).sorted(byKeyPath: "dateAdded", ascending: true)
    
    //Array of RealmUpdatables to update when something in the realm changes
    var realmUpdatables : Array<RealmUpdatable> = []
    
    
    //Add a beer to the realm
    func addBeer(beer : Beer, shouldUpdateTable: Bool,completion: @escaping (Error?) -> Void) {
        do {
            let realm = try Realm()
            try realm.write {
                //Set dateAdded of the beer to today
                beer.dateAdded = Date()
                realm.add(beer)
            }
            
            self.updateResultsList()
            self.updateRealmUpdatables(shouldUpdateTable: shouldUpdateTable)
        } catch let error as NSError {
            completion(error)
            return
        }
        completion(nil)
        
    }
    
    //Remove a beer from the realm
    func removeBeer(beer:Beer, shouldUpdateTable: Bool,completion: @escaping (Error?) -> Void)  {
        do {
            let realm = try Realm()
            try realm.write {
                let id = beer.id
                realm.delete(beer)
                DocumentsDirectoryController.singleton.removeImage(fileName: id)
            }
            self.updateResultsList()
            self.updateRealmUpdatables(shouldUpdateTable: shouldUpdateTable)
        } catch let error as NSError {
            completion(error)
            return
        }
        completion(nil)
    }
    
    //Update an existing beer in the realm
    func updateBeer(realmBeer : Beer, dataBeer : Beer,shouldUpdateTable : Bool,completion: @escaping (Error?) -> Void) {
        do {
            let realm = try Realm()
            try realm.write {
                let id = realmBeer.id
                
                realmBeer.id = dataBeer.id
                realmBeer.name = dataBeer.name
                realmBeer.beerDescription = dataBeer.beerDescription
                realmBeer.alcoholByVolume = dataBeer.alcoholByVolume
                realmBeer.internationalBitteringUnit = dataBeer.internationalBitteringUnit
                realmBeer.originalGravity = dataBeer.originalGravity
                realmBeer.foodPairings = dataBeer.foodPairings
                realmBeer.isRetired.value = dataBeer.isRetired.value
                realmBeer.isOrganic.value = dataBeer.isOrganic.value
                realmBeer.year.value = dataBeer.year.value
                
                DocumentsDirectoryController.singleton.removeImage(fileName: id)
            }
            self.updateResultsList()
            self.updateRealmUpdatables(shouldUpdateTable: shouldUpdateTable)
        } catch let error as NSError {
            completion(error)
            return
        }
        completion(nil)
    }
    
    //Adding a single note to a beer in the realm
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
    
    //Removing a single note to a beer in the realm
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
    
    //Check if our beer is already saved in the realm
    func hasBeerAlreadySaved(beer : Beer) -> Bool{
        if let _ = beers.firstIndex(where: {
            $0 == beer
        }) {
            return true
        }
        return false
    }
    
    //Adding a realmUpdatable, these gets updated when beers get removed or added to the realm, or updated within the realm
    func addRealmUpdatable(updatable : RealmUpdatable) {
        realmUpdatables.append(updatable)
    }
    
    //We update all realmUpdatables that have been registered in our list "realmUpdatables"
    func updateRealmUpdatables(shouldUpdateTable : Bool) {
        realmUpdatables.forEach {obj in
            obj.updateData(shouldUpdateTable: shouldUpdateTable)
        }
    }
    
   
    
    
}
