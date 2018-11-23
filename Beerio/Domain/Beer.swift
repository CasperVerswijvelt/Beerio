//
//  Beer.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 21/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import Foundation

class Beer : Codable{
    var id: String
    var name: String
    var description: String?
    var foodPairings: String?
    var originalGravity: String?
    var alcoholByVolume: String? //abv
    var internationalBitteringUnit: String? //ibu
    var isRetired: String?
    var glass: Glass?
    var isOrganic: String?
    var labels : Labels?
    var servingTemperature : String? //servingTemperatureDisplay
    var status : String?
    var year: Int?
    
    
    func getValues() -> [BeerSectionInfo] {
        var sections : [BeerSectionInfo] = []
        
        //Section with basic info (name and description)
        var basicInfo = BeerSectionInfo(header: "Basic info", cells: [])
        basicInfo.cells.append(BeerCellInfo(key: "Name", value: name, cellType: .SIMPLE))
        basicInfo.cells.appendCellIfValueIsPresent(key: "Description", value: description, cellType : .LARGE)
        
        //Section with numbers and stuff
        var numbers = BeerSectionInfo(header: "Numbers and stuff", cells: [])
        numbers.cells.appendCellIfValueIsPresent(key: "Original Gravity", value: originalGravity, cellType: .SIMPLE)
        numbers.cells.appendCellIfValueIsPresent(key: "Alcohol By Volume", value: alcoholByVolume, cellType: .SIMPLE)
        numbers.cells.appendCellIfValueIsPresent(key: "International Bittering Unit", value: internationalBitteringUnit, cellType: .SIMPLE)
        numbers.cells.appendCellIfValueIsPresent(key: "Serving Temperature", value: servingTemperature, cellType: .SIMPLE)
        
        
        sections.appendSectionIfHasCells(basicInfo)
        sections.appendSectionIfHasCells(numbers)
        
        
        return sections
    }
    
    
    private enum CodingKeys : String, CodingKey {
        case id
        case name
        case description
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
    
    
    
    
}

class Beers : Codable {
    var beers : [Beer]?
    
    private enum CodingKeys : String, CodingKey {
        case beers = "data"
    }
}

extension Array where Iterator.Element == BeerSectionInfo  {
    mutating func appendSectionIfHasCells(_ section : BeerSectionInfo) {
        if(section.cells.count != 0) {
            self.append(section)
        }
    }
}

extension Array where Iterator.Element == BeerCellInfo  {
    mutating func appendCellIfValueIsPresent(key: String, value: String?, cellType: CellType) {
        if let value = value {
            self.append(BeerCellInfo(key: key, value: value, cellType: cellType) )
        }
    }
}
