//
//  ImageViewController.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 23/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import UIKit
import Toast_Swift

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var beer: Beer!
    var loader : UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Loader
        loader.center = self.view.center
        loader.hidesWhenStopped = true
        self.view.addSubview(loader)
        
        //Scroll
        scrollView.contentSize=CGSize(width: 1280, height:960);
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        
        
        loadImage()

        // Do any additional setup after loading the view.
    }
    

    func loadImage() {
        if let image = DocumentsDirectoryController.singleton.getImage(fileName: beer.id) {
            self.imageView.image = image 
        } else {
            if let imageURL = beer.labels?.large {
                loader.startAnimating()
                NetworkController.singleton.fetchImage(with: imageURL) {image in
                    DispatchQueue.main.async {
                        self.imageView.image = image
                        self.setZoomScale()
                        self.loader.stopAnimating()
                    }
                }
            } else {
                //No image to display, they shouldn't even be able to get to this page if this is the case
                
            }
        }
        
        
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    //SOURCE: https://stackoverflow.com/a/40245415
    // I run this method after i set the image in the imageView, so you can't zoom out further than  the image filling the screen
    func setZoomScale() {
        var minZoom = min(self.view.bounds.size.width / imageView!.bounds.size.width, self.view.bounds.size.height / imageView!.bounds.size.height);
        if (minZoom > 1.0) {
            minZoom = 1.0;
        }
        scrollView.minimumZoomScale = minZoom;
        scrollView.zoomScale = minZoom;
    }
    
    
    @IBAction func actionTapped(_ sender: Any) {
        let alert = UIAlertController(title: "What to save?", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Image", style: .default) { alert in
            guard let image = self.imageView.image else {return}
            let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            
            activityController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            self.present(activityController,animated: true, completion: nil)
        })
        alert.addAction(UIAlertAction(title: "Image URL", style: .default) { alert in
            let pasteBoard = UIPasteboard.general
            var style = ToastStyle()
            style.backgroundColor = UIColor.lightGray
            if let imageURL = self.beer.labels?.large {
                pasteBoard.string = imageURL.absoluteString
                //SHow notification that it succeeded
                self.view.makeToast("Image URL copied to clipboard!", duration: 4.0, style: style)
            } else {
                //Show notification that it has failed
                self.view.makeToast("This image doesn't have an URL", duration: 4.0, style: style)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        //For Ipad: popover location
        alert.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        
        self.present(alert, animated: true)
    }
}
