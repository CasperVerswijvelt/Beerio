//
//  BeersTableViewController.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 22/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class BeersTableViewController: LoaderTableViewController {
    
    var beers : [Beer]?
    var style : Style?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let style = style {
            loadBeers(for: style.id)
        }
        
        //Empty Dataset
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
    }

    // Data source methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return beers?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "beerCell", for: indexPath)

        // Configure the cell...
        let beer = beers?[indexPath.row]

        cell.textLabel?.text = beer?.name
        
        return cell
    }
    
    //Loading data from API
    func loadBeers(for styleId: Int) {
        showLoader()
        BeerController.singleton.fetchBeers(for: styleId) {beers in
            
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
        let str = "No beers could be found for this style :'("
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    // Add your image
    func image(forEmptyDataSet _: UIScrollView!) -> UIImage! {
        return UIImage(named: "beerIcon.pdf")
    }
    
    // Add your button
    func buttonTitle(forEmptyDataSet _: UIScrollView!, for _: UIControl.State) -> NSAttributedString! {
        let str = "Yeet"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.callout), NSAttributedString.Key.foregroundColor: UIColor.blue]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    // Add action for button
    func emptyDataSetDidTapButton(_: UIScrollView!) {
        let ac = UIAlertController(title: "Button tapped!", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Hurray", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBeer", let dest = segue.destination as? BeerDetailsTableViewController, let beerIndex = tableView.indexPathForSelectedRow?.row, let beers = beers {
            dest.beer = beers[beerIndex]
        }
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
