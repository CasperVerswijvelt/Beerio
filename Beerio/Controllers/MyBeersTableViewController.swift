//
//  MyBeersTableViewController.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 21/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import UIKit

class MyBeersTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var addBeerButton: UIButton!
    
    //Vars
    var localBeerList = RealmController.singleton.beers
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        //We set this table to update whenever something in the Realm changes, so if another view adds something to the realm, this tableview is automaticcaly up to date
        RealmController.singleton.setTableViewToUpdate(tableView)
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        addBeerButton.layer.cornerRadius = 10
        
    }
    
    //Data source methods
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return RealmController.singleton.beers.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete) {
            RealmController.singleton.removeBeer(beer: localBeerList[indexPath.row], shouldUpdateTable: false) {error in
                if let error = error {
                    Toaster.makeErrorToast(view: self.navigationController?.view, text: "Couldn't delete beer from library: \(error.localizedDescription)")
                } else {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
                
            }
        }
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "beerCell", for: indexPath)
        
        let beer = localBeerList[indexPath.row]
        // Configure the cell...
        cell.textLabel?.text = beer.name
        
        return cell
    }
    
    
    
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMyBeer", let destination = segue.destination as? BeerDetailsTableViewController, let beerIndex = tableView.indexPathForSelectedRow?.row {
            destination.beer = RealmController.singleton.beers[beerIndex]
            destination.isLocal = true
        }
    }
    @IBAction func newBeerTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.addBeerButton.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }, completion: { bool in
            UIView.animate(withDuration: 0.2, animations: {
                self.addBeerButton.transform = CGAffineTransform.identity
                self.performSegue(withIdentifier: "showNewBeerScreen", sender: self)
            })
        })
    }
    @IBAction func unwindToMyBeersScreen(segue:UIStoryboardSegue) {
        
    }
}
