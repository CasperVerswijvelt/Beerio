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
        sections.append(BeerSectionInfo(header: "Basic info", cells: [
            BeerCellInfo(key: "Name", value: name, cellType: .SIMPLE),
            BeerCellInfo(key: "Description", value: description ?? "Description unknown", cellType : .LARGE),
            ]))
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
