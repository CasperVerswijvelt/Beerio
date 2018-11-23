//
//  ImageViewController.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 23/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var imageURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImage()

        // Do any additional setup after loading the view.
    }
    

    func loadImage() {
        if let imageURL = imageURL {
            imageView.showLoader()
            BeerController.singleton.fetchImage(with: imageURL) {image in
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.imageView.hideLoader()
                }
            }
        }
    }

}
