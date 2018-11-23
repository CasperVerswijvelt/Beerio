//
//  ApiError.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 23/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import Foundation

enum APIError: Error {
    case KeyInvalid(String)
    case KeyNotSet(String)
}
