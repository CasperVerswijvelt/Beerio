//
//  BeerController.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 21/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import Foundation

class BeerController {
    static let singleton : BeerController = BeerController()
    
    let baseUrl : URL = URL(string: "https://api.brewerydb.com/v2/")!
    
    func fetchCategories(completion: @escaping ([Category]?) -> Void) {
        guard let API_KEY = SettingsBundleHelper().API_KEY else {
            
            return}
        
        
        let stylesUrl = baseUrl.appendingPathComponent("categories")
        var components = URLComponents(url: stylesUrl, resolvingAgainstBaseURL: false)
        
        components?.queryItems = [URLQueryItem(name: "key", value: API_KEY)]
        if let url = components?.url {
            
            let task = URLSession.shared.dataTask(with: url) {
                (data,response,error) in
                let jsonDecoder = JSONDecoder()
                if let data = data, let categories = try? jsonDecoder.decode(Categories.self, from: data) {
                    
                    completion(categories.categories)
                } else {
                    completion(nil)
                }
                
                
            }
            task.resume()
        } else {
            completion(nil)
        }
        
        
    }
    
}
