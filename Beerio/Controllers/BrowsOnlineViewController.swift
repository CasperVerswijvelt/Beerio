//
//  BrowsOnlineViewController.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 27/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import UIKit

class BrowsOnlineViewController: UINavigationController {
    
    var alertView : UIView!
    var alertViewController : ApiKeyInvalidPopUpViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertViewController = self.storyboard?.instantiateViewController(withIdentifier: "ApiKeyInvalidPopUpViewController") as? ApiKeyInvalidPopUpViewController
        alertView = alertViewController?.view
        
        alertViewController.takeMeToSettingsButton.addTarget(self, action: #selector(takeMeToSettings), for: .primaryActionTriggered)

        
        //Checking if entered API Key is correct
        NotificationCenter.default.addObserver(self, selector: #selector(self.doAPIKeyCheck), name: UserDefaults.didChangeNotification, object: nil)
        doAPIKeyCheck()
    }
    

    //objc so we can call it in our listener that listens to changes in our app settings
    @objc func doAPIKeyCheck() {
        print("checking api key")
        NetworkController.singleton.isAPIKeyValid() { bool in
            DispatchQueue.main.async {
                if(!bool) {
                    self.showAlert()
                } else {
                    self.hideAlert()
                }
            }
        }
    }
    
    @objc func takeMeToSettings() {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString+":root=Beerio")!, options:[:]) {
                Bool in
            }
        }
        //Else : we don't show the button under IOS 10 so there is no 'else' necesary
    }
    
    func showAlert() {
        if(!self.view.subviews.contains(alertView)) {
            self.alertViewController.setInitiallyTransparent()
            self.view.addSubview(self.alertView)
            alertViewController.fadeIn {
            }
        }
    }
    
    func hideAlert() {
        if self.alertView.isDescendant(of: self.view) {
            alertViewController.fadeOut {
                self.alertView.removeFromSuperview()
                if let reloadable = self.visibleViewController as? Reloadable {
                    reloadable.reloadData()
                }
            }
        }
        
    }

}
