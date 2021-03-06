//
//  BeerSection.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 23/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import Foundation

//This class contains all info that should be displayed in a single section in a BeerDetailTableView
struct BeerSectionInfo {
    var header : String
    var cells : [BeerCellInfo]
    var isNotes : Bool = false
}

extension BeerSectionInfo {
    init(header:String)  {
        self.init(header : header, cells:[], isNotes:false)
    }
}

