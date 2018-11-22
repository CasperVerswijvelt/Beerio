//
//  StylesTableViewController.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 21/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import UIKit

class StylesTableViewController: LoaderTableViewController {
    
    //Attributes
    var category : Category? {
        didSet {
            if let category = self.category {
                self.navigationItem.title = category.name
                loadStyles(category.id)
            }
        }
        
    }
    var styles : [Style] = []
    
    //Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //Data source methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return styles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "styleCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = styles[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return category?.description
    }
    
    
    
    
    //
    func loadStyles(_ categoryId : Int) {
        self.showLoader()
        BeerController.singleton.fetchStyles(for: categoryId) { styles in           
            if let styles  = styles {
                DispatchQueue.main.async {
                    self.styles = styles
                    self.tableView.reloadData()
                }
                
            }
            self.hideLoader()
        }
    }
 

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBeersForStyle", let destination = segue.destination as? BeersTableViewController {
            
            if let selectedIndex = tableView.indexPathForSelectedRow?.row {
                let selectedStyle = styles[selectedIndex]
                destination.style = selectedStyle
            }
        }
    }

}
