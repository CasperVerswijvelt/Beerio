//
//  Beer.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 21/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Beer : Object, Decodable {
    //Variables
    @objc dynamic var id: String=""
    @objc dynamic var name: String=""
    @objc dynamic var beerDescription: String?
    @objc dynamic var foodPairings: String?
    @objc dynamic var originalGravity: String?
    @objc dynamic var alcoholByVolume: String? //abv
    @objc dynamic var internationalBitteringUnit: String? //ibu
    @objc dynamic var labels : Labels?
    @objc dynamic var servingTemperature : String? //servingTemperatureDisplay
    @objc dynamic var status : String?
    @objc dynamic var dateAdded : Date?
    @objc dynamic var isSelfMade = false;
    var notes : List<Note> = List<Note>()
    
    //Realm can't save 'Int?' and 'Bool?', so we make realmoptionals
    var year : RealmOptional<Int> = RealmOptional<Int>()
    var isRetired: RealmOptional<Bool> = RealmOptional<Bool>()
    var isOrganic: RealmOptional<Bool> = RealmOptional<Bool>()
    
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
    
    
    //Codable
    private enum CodingKeys : String, CodingKey {
        case id
        case name
        case beerDescription = "description"
        case foodPairings
        case originalGravity
        case alcoholByVolume = "abv"
        case internationalBitteringUnit = "ibu"
        case isRetired
        case glass
        case isOrganic
        case labels
        case servingTemperature = "servingTemperatureDisplay"
        case status
        case year
    }
    
    required init(from decoder:Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: CodingKeys.id)
        self.name = try container.decode(String.self, forKey: CodingKeys.name)
        self.beerDescription = try container.decodeIfPresent(String.self, forKey: CodingKeys.beerDescription)
        self.foodPairings = try container.decodeIfPresent(String.self, forKey: CodingKeys.foodPairings)
        self.originalGravity = try container.decodeIfPresent(String.self, forKey: CodingKeys.originalGravity)
        self.alcoholByVolume = try container.decodeIfPresent(String.self, forKey: CodingKeys.alcoholByVolume)
        self.internationalBitteringUnit = try container.decodeIfPresent(String.self, forKey: CodingKeys.internationalBitteringUnit)
        self.labels = try container.decodeIfPresent(Labels.self, forKey: CodingKeys.labels)
        self.servingTemperature = try container.decodeIfPresent(String.self, forKey: CodingKeys.servingTemperature)
        self.status = try container.decodeIfPresent(String.self, forKey: CodingKeys.status)
        
        //Variables that need some processing
        let isRetired = try container.decodeIfPresent(String.self, forKey: CodingKeys.isRetired)
        let isOrganic = try container.decodeIfPresent(String.self, forKey: CodingKeys.isOrganic)
        let year = try container.decodeIfPresent(Int.self, forKey: CodingKeys.year)
        
        if let isRetired = isRetired {
            if isRetired == "Y" {
                self.isRetired.value = true
            } else if isRetired == "N" {
                self.isRetired.value = false
            }
        }
        if let isOrganic = isOrganic {
            if isOrganic == "Y" {
                self.isOrganic.value = true
            } else if isOrganic == "N" {
                self.isOrganic.value = false
            }
        }
        if let year = year {
            self.year.value = year
        }

    }
    
    //If we don't have a image locally saved for this id, and there is an url for an image present, we fetch it and persist it in our documents directory
    func fetchAndSaveImageIfNotAlreadySaved() {
        guard DocumentsDirectoryController.singleton.getImage(fileName: self.id) == nil, let labels = labels,let originalUrl = labels.large else {return}
        //After this guard we are sure that there is no image saved yet, and we have a large image to persist
        
        //We recreate the objects we will need in another thread, if we use the original objects we will get a Realm exception
        let urlToPersist = URL(string: originalUrl.absoluteString)
        let id = String(self.id)
        
        NetworkController.singleton.fetchImage(with: urlToPersist!) {image in
            if let image = image {
                DocumentsDirectoryController.singleton.saveImageDocumentDirectory(image: image, fileName: id)
            }
        }
    }
    
    //Saving a custom image for a beer in the documents directory, no url involved
    func saveCustomImage(image : UIImage) {
        DocumentsDirectoryController.singleton.saveImageDocumentDirectory(image: image, fileName: id)
    }
    
    //Generating a random id for new beer Objecrs
    func generateRandomId() {
        let length = 10
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var randomString = ""
        
        for _ in 0...length {
            randomString += String(letters.randomElement()!)
        }
        
        self.id = randomString
    }
    
    //Equatable implementation
    static func == (lhs: Beer, rhs: Beer) -> Bool {
        return lhs.id == rhs.id
    }
    
}

//beers class, to decode to from json
class Beers : Decodable {
    var beers : [Beer]?
    
    private enum CodingKeys : String, CodingKey {
        case beers = "data"
    }
}


//EXTENSIONS
extension Array where Iterator.Element == BeerSectionInfo  {
    mutating func appendSectionIfHasCells(_ section : BeerSectionInfo) {
        if(section.cells.count != 0) {
            self.append(section)
        }
    }
}

extension Array where Iterator.Element == BeerCellInfo  {
    mutating func appendCellIfValueIsPresent(key: String, value: Any?, cellType: CellType) {
        if let value = value {
            var beerCellInfo = BeerCellInfo(key: key, value: nil, cellType: cellType)
            if let value = value as? String {
                beerCellInfo.value = value
            }
            if let value = value as? Int {
                beerCellInfo.value = String(value)
            }
            if let value = value as? Bool {
                beerCellInfo.value = value ? "Yes" : "No"
            }

            self.append(beerCellInfo)
            
        }
    }
}

//Extension on class beer, I moved it onto an extension so the beer class itself isn'nt bloated
//  -> To transform to data that a table can easily read
extension Beer {
    //Get only variable
    var tableLayout : [BeerSectionInfo] {
        get {
            var sections : [BeerSectionInfo] = []
            
            //Section with basic info (name and description)
            var basicInfo = BeerSectionInfo(header: "Basic info")
            basicInfo.cells.append(BeerCellInfo(key: "Name", value: name, cellType: .LARGE))
            basicInfo.cells.appendCellIfValueIsPresent(key: "Description", value: beerDescription, cellType : .LARGE)
            
            //Section with numbers and stuff
            var numbers = BeerSectionInfo(header: "Numbers and stuff")
            numbers.cells.appendCellIfValueIsPresent(key: "Original Gravity", value: originalGravity, cellType: .SIMPLE)
            numbers.cells.appendCellIfValueIsPresent(key: "Alcohol By Volume", value: alcoholByVolume, cellType: .SIMPLE)
            numbers.cells.appendCellIfValueIsPresent(key: "International Bittering Unit", value: internationalBitteringUnit, cellType: .SIMPLE)
            numbers.cells.appendCellIfValueIsPresent(key: "Serving Temperature", value: servingTemperature, cellType: .LARGE)
            
            //Section about other random stuff
            var random = BeerSectionInfo(header: "Other")
            random.cells.appendCellIfValueIsPresent(key: "Food Pairings", value: foodPairings, cellType: CellType.LARGE)
            random.cells.appendCellIfValueIsPresent(key: "Is retired", value: isRetired.value, cellType: CellType.SIMPLE)
            random.cells.appendCellIfValueIsPresent(key: "Is organic", value: isOrganic.value, cellType: CellType.SIMPLE)
            random.cells.appendCellIfValueIsPresent(key: "Year", value: year.value, cellType: CellType.SIMPLE)
            random.cells.appendCellIfValueIsPresent(key: "Bottle Label", value: (DocumentsDirectoryController.singleton.getImage(fileName: id) != nil || labels?.large != nil) ? true : nil  , cellType: CellType.IMAGE)
            
            var dateAdded = BeerSectionInfo(header: "Added to local library")
            let df = DateFormatter()
            df.dateStyle = .medium
            dateAdded.cells.appendCellIfValueIsPresent(key: "Date", value: df.string(for: self.dateAdded), cellType: .SIMPLE)
            
            var notes = BeerSectionInfo(header: "Personal notes")
            self.notes.forEach { note in
                notes.cells.append(BeerCellInfo(key: df.string(from: note.date), value: note.text, cellType: .LARGE))
            }
            notes.isNotes = true
            
            sections.appendSectionIfHasCells(basicInfo)
            sections.appendSectionIfHasCells(numbers)
            sections.appendSectionIfHasCells(random)
            sections.appendSectionIfHasCells(dateAdded)
            sections.appendSectionIfHasCells(notes)
            
            return sections
        }
        set {}
    }
}
