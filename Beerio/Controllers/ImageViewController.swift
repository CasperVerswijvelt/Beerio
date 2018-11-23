//
//  ImageViewController.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 23/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var imageURL: URL?
    var loader : UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Loader
        loader.center = self.view.center
        loader.hidesWhenStopped = true
        self.view.addSubview(loader)
        
        //Scroll
        scrollView.contentSize=CGSize(width: 1280, height:960);
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 10.0
        
        
        loadImage()

        // Do any additional setup after loading the view.
    }
    

    func loadImage() {
        if let imageURL = imageURL {
            loader.startAnimating()
            NetworkController.singleton.fetchImage(with: imageURL) {image in
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.setZoomScale()
                    self.loader.stopAnimating()
                }
            }
        }
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func setZoomScale() {
        var minZoom = min(self.view.bounds.size.width / imageView!.bounds.size.width, self.view.bounds.size.height / imageView!.bounds.size.height);
        if (minZoom > 1.0) {
            minZoom = 1.0;
        }
        scrollView.minimumZoomScale = minZoom;
        scrollView.zoomScale = minZoom;
    }
}
