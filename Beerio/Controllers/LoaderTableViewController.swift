//
//  Extensions.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 22/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import Foundation
import UIKit
import DZNEmptyDataSet

class LoaderTableViewController :  UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    var activityIndicatorView : UIActivityIndicatorView!
    var isShowingLoader : Bool = false
    
    
    override func loadView() {
        super.loadView()
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        tableView.backgroundView = activityIndicatorView
    }
    
    //Loader methods
    func showLoader() {
        self.isShowingLoader = true
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.activityIndicatorView.startAnimating()
            self.tableView.separatorStyle = .none
            self.tableView.reloadEmptyDataSet()
        }
    }
    func hideLoader() {
        self.isShowingLoader = false
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
            self.tableView.separatorStyle = .singleLine
            self.tableView.reloadEmptyDataSet()
        }
    }
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return !isShowingLoader
    }
    
}
