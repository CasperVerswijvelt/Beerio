//
//  BeerCellInfo.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 23/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import Foundation

//This class contains all info that should be displayed in a single cell in a BeerDetailTableView
struct BeerCellInfo {
    var key : String
    var value : String?
    var cellType : CellType = CellType.SIMPLE
    
}
