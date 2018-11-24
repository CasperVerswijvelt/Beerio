//
//  BeerDetailsTableViewController.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 23/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import UIKit

class BeerDetailsTableViewController: LoaderTableViewController {
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var beer : Beer? {
        didSet {
            if let beer = beer {
                self.addButton.isEnabled = true
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
    @IBAction func addTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add to 'My Beers'", message: "Are you sure you want to add \(beer!.name) to your personal beer library?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default) { alert in
            if let beer = self.beer {
                LocalController.singleton.addBeer(beer: beer)
            }
        })
        self.present(alert, animated: true)
        
    }
}
