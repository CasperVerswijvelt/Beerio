//
//  BrowseBeersTableViewController.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 21/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import UIKit

class CategoriesTableViewController: LoaderTableViewController, UISearchBarDelegate, Reloadable{
    
    
    
    //Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    //Attributes
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
    var apiKeyInvalidAlert : UIAlertController!
    
    
    
    //Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.hidesSearchBarWhenScrolling = true
        self.searchBar.delegate = self;
        loadCategories()
    }
    
    

    
    //Retrieving data from controller
    func loadCategories() {
        self.categories = []
        self.showLoader()
        NetworkController.singleton.fetchCategories {
            (categories) in
            if let categories = categories {
                self.categories = categories
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top , animated: true)
                }
            }
            self.hideLoader()
            
        }
    }
    
    
    // Data source methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCategories.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
        
        // Configure the cell...
        cell.nameLabel?.text = filteredCategories[indexPath.row].name
        cell.descriptionLabel.text = filteredCategories[indexPath.row].description
        
        return cell
    }
    
    //Reloadable protocol
    func reloadData() {
        if categories.count == 0 {
            loadCategories()
        }
    }
    
    
    //Search bar methods
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showStylesForCategory"), let stylesController =  segue.destination as? StylesTableViewController {
            
            let selectedRow = tableView.indexPathForSelectedRow?.row
            if let selectedRow = selectedRow {
                let selectedCategory = self.filteredCategories[selectedRow]
                stylesController.category = selectedCategory
            }
        }
        
    }
    
    //IBActions
    @IBAction func refreshTapped(_ sender: Any) {
        loadCategories()
    }
    
    
    
    
    
}
