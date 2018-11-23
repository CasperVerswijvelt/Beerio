//
//  BeerController.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 21/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import Foundation
import UIKit

class NetworkController {
    static let singleton : NetworkController = NetworkController()
    
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
    
    //Unfortunately with this api we can't get all styles based on a category
    //  Instead we get all styles, cache these and filter
    func fetchStyles(for categoryId: Int, completion: @escaping ([Style]?) -> Void) {
        guard let API_KEY = SettingsBundleHelper().API_KEY else {
            completion(nil)
            return}
        
        
        let beersUrl = baseUrl.appendingPathComponent("styles")
        var components = URLComponents(url: beersUrl, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "key", value: API_KEY)]
        
        if let url = components?.url {
            let task = URLSession.shared.dataTask(with: url) {
                (data,response,error) in
                let jsonDecoder = JSONDecoder()
                if let data = data, let styles = try? jsonDecoder.decode(Styles.self, from: data) {
                    
                    completion(styles.styles.filter { (style) -> Bool in
                        return style.categoryId == categoryId
                    })
                } else {
                    completion(nil)
                }
            }
            task.resume()
        } else {
            completion(nil)
        }

    }
    
    func fetchBeers(for styleId: Int, completion: @escaping ([Beer]?) -> Void) {
        guard let API_KEY = SettingsBundleHelper().API_KEY else {
            completion(nil)
            return}
        
        
        let beersUrl = baseUrl.appendingPathComponent("beers")
        var components = URLComponents(url: beersUrl, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "key", value: API_KEY),
                                  URLQueryItem(name: "styleId", value: String(styleId))]
        
        if let url = components?.url {
            let task = URLSession.shared.dataTask(with: url) {
                (data,response,error) in
                let jsonDecoder = JSONDecoder()
                if let data = data, let beers = try? jsonDecoder.decode(Beers.self, from: data) {
                    completion(beers.beers)
                } else {
                    completion(nil)
                }
            }
            task.resume()
        } else {
            completion(nil)
        }
        
        
    }
    
    
    //To fetch a specific beer by id
    func fetchStyles( beerId: Int, completion: @escaping (Beer?) -> Void) {
        guard let API_KEY = SettingsBundleHelper().API_KEY else {
            completion(nil)
            return}
        
        
        let beerUrl = baseUrl.appendingPathComponent("styles")
        var components = URLComponents(url: beerUrl, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "key", value: API_KEY),
                                  URLQueryItem(name: "id", value: String(beerId))]
        
        if let url = components?.url {
            let task = URLSession.shared.dataTask(with: url) {
                (data,response,error) in
                let jsonDecoder = JSONDecoder()
                if let data = data, let beer = try? jsonDecoder.decode(Beer.self, from: data) {
                    
                    completion(beer)
                } else {
                    completion(nil)
                }
            }
            task.resume()
        } else {
            completion(nil)
        }
    }
    
    //Fetching label image via url
    func fetchImage(with url : URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data,
            response, error) in
            if let data = data {
                let image = UIImage(data: data)
                completion(image)
            } else {
                completion(nil)
            }
        }
        
        task.resume()
    }
    
}
