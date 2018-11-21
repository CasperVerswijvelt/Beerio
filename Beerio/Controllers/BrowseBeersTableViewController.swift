//
//  BrowseBeersTableViewController.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 21/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import UIKit

class BrowseBeersTableViewController: UITableViewController, UISearchBarDelegate{
    @IBOutlet weak var searchBar: UISearchBar!
    
    var categories : [Category] = [] {
        didSet {
            DispatchQueue.main.async {
                self.searchBar.text = nil
                self.filteredCategories = self.categories
            }
        }
    }
    var filteredCategories : [Category] = []
    
    var searchFilter : String = "" {
        didSet {
            updateFilteredList()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesSearchBarWhenScrolling = true
        self.searchBar.delegate = self;
        
        BeerController.singleton.fetchCategories {
            (categories) in
            if let categories = categories {
                self.categories = categories
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top , animated: true)
                }
            }
        }
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCategories.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell

        // Configure the cell...
        cell.nameLabel?.text = filteredCategories[indexPath.row].name
        cell.descriptionLabel.text = filteredCategories[indexPath.row].description

        return cell
    }
    
    
    
    //Search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchFilter = searchText
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }
    func updateFilteredList() {
        self.filteredCategories = self.categories.filter { (newValue) -> Bool in
            if searchFilter.count == 0 {
                return true
            } else {
                return newValue.name.lowercased().range(of: searchFilter.lowercased()) != nil || newValue.description?.lowercased().range(of: searchFilter.lowercased()) != nil
            }
            
            
        }
        tableView.reloadData()
    }
    func dismissKeyboard() {
        self.searchBar.endEditing(true)
    }
    

    

}
