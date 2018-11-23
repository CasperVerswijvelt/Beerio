//
//  BeerDetailsTableViewController.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 23/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import UIKit

class BeerDetailsTableViewController: LoaderTableViewController {
    
    var beer : Beer? {
        didSet {
            if let beer = beer {
                self.navigationItem.title = beer.name
               beerDetails = beer.getValues()
                tableView.reloadData()
            }
            
        }
    }
    var beerDetails : [BeerSectionInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return beerDetails.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return beerDetails[section].cells.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let beerCellInfo = beerDetails[indexPath.section].cells[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: beerCellInfo.cellType.rawValue, for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = beerCellInfo.key
        cell.detailTextLabel?.text = beerCellInfo.value

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let beerSectionInfo = beerDetails[section]
        return beerSectionInfo.header
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLabel", let destination = segue.destination as? ImageViewController, let cellIndex = tableView.indexPathForSelectedRow {
            
            destination.imageURL = self.beerDetails[cellIndex.section].cells[cellIndex.row].url
        }
    }
}
