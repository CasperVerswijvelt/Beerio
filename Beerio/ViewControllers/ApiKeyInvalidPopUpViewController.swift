//
//  ApiKeyInvalidPopUpViewController.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 27/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import UIKit

class ApiKeyInvalidPopUpViewController: UIViewController {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var takeMeToSettingsButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.clipsToBounds = true
        self.popUpView?.layer.cornerRadius = 20.0
    
        if #available(iOS 10.0, *)  {
            descriptionLabel?.text = "It seems that you either have not entered your BreweryDB API key in the settings yet, or it is invalid. Go to settings and enter a valid API Key"
        } else {
            descriptionLabel?.text = "It seems that you either have not entered your BreweryDB API key in the settings yet, or it is invalid. Please go to 'Settings App -> Beerio -> BreweryDB API Key' and enter a valid API Key."
            takeMeToSettingsButton.isHidden = true
        }
    }
    
    func setInitiallyTransparent() {
        self.view.alpha = 0.0
    }
    
    func fadeOut(callBack : @escaping () -> Void) {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: [],
                       animations: {
                        self.popUpView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        },completion: { Void in() })
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
            self.view.alpha = 0.0
            
        }, completion: { (finished: Bool) in
            callBack()
        })
    }
    func fadeIn(callBack : @escaping () -> Void) {
        self.popUpView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.7),
                       initialSpringVelocity: CGFloat(3.0),
                       options: [],
                       animations: {
                       self.popUpView.transform = CGAffineTransform.identity
        },completion: { Void in()  })
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
            self.view.alpha = 1.0
        }, completion: { (finished: Bool) in
            callBack()
        })
    }
    
    
    


}
