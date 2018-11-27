//
//  BeersTableViewController.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 22/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class BeersTableViewController: LoaderTableViewController, Reloadable {
    
    var beers : [Beer] = []
    var style : Style?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let style = style {
            self.navigationItem.title = style.name
            loadBeers(for: style.id)
        }
        
        //Empty Dataset
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
    }
    override func viewWillAppear(_ animated: Bool) {
        if let _ = tableView.indexPathForSelectedRow {
            //We reload the last selected row, in case it ws added to our personal library, then a checkmark should appear
            //tableView.reloadRows(at: [index], with: .automatic)
            // ^ Apparently this does something wrong that changes the images in a wrong manner. I really don't want to deal with this so i reload the whole table
            tableView.reloadData()
        }
        
    }

    // Data source methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return beers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "beerCell", for: indexPath) as! BeerTableViewCell

        // Configure the cell...
        let beer = beers[indexPath.row]
        
        cell.beerNameLabel?.text = beer.name
        if(RealmController.singleton.hasBeerAlreadySaved(beer: beer)) {
            //print("\(beer.name) is already saved, displayin checkmark")
            cell.accessoryType = .checkmark
        }
        
        //If icon exists, fetch and display it
        if let icon = beer.labels?.icon {
            NetworkController.singleton.fetchImage(with: icon) { image in
                if let image = image {
                    DispatchQueue.main.async {
                        cell.setIconImage(image: image)
                    }
                }
            }
        } else {
            cell.setIconImage(image: UIImage(named: "beerIcon.pdf")!)
        }
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    //Reloadable API
    func reloadData() {
        if let style = style, beers.count == 0 {
            loadBeers(for: style.id)
        }
    }
    
    
    //Loading data from API
    func loadBeers(for styleId: Int) {
        showLoader()
        NetworkController.singleton.fetchBeers(for: styleId) {beers in
            
            DispatchQueue.main.async {
                if let beers = beers {
                    self.beers = beers
                    self.tableView.reloadData()
                }
                self.hideLoader()
                self.tableView.reloadEmptyDataSet()
            }
        }
    }
    
    // Dealing with empty datasets
    // Add title for empty dataset
    func title(forEmptyDataSet _: UIScrollView!) -> NSAttributedString! {
        let str = "Woops!"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    // Add description/subtitle on empty dataset
    func description(forEmptyDataSet _: UIScrollView!) -> NSAttributedString! {
        let str = "This style doesn't contain any beer :'("
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    // Add your image
    func image(forEmptyDataSet _: UIScrollView!) -> UIImage! {
        return UIImage(named: "beerIcon.pdf")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBeer", let dest = segue.destination as? BeerDetailsTableViewController, let beerIndex = tableView.indexPathForSelectedRow?.row {
            dest.beer = beers[beerIndex]
        }
    }


}
