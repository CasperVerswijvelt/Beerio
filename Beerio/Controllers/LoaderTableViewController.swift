//
//  Extensions.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 22/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import Foundation
import UIKit

class LoaderTableViewController :  UITableViewController {
    var activityIndicatorView : UIActivityIndicatorView!
    
    
    override func loadView() {
        super.loadView()
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        tableView.backgroundView = activityIndicatorView
    }
    
    //Loader methods
    func showLoader() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.activityIndicatorView.startAnimating()
            self.tableView.separatorStyle = .none
        }
    }
    func hideLoader() {
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
            self.tableView.separatorStyle = .singleLine
        }
    }
    
    
}
