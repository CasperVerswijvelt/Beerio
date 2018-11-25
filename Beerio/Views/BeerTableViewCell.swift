//
//  BeerTableViewCell.swift
//  Beerio
//
//  Created by Casper Verswijvelt on 25/11/2018.
//  Copyright © 2018 Casper Verswijvelt. All rights reserved.
//

import UIKit

class BeerTableViewCell: UITableViewCell {
    private var iconImageWasSet = false
    @IBOutlet private weak var iconImage: UIImageView!
    @IBOutlet weak var beerNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setIconImage(image : UIImage) {
        if(!iconImageWasSet) {
            iconImageWasSet = true
            iconImage.image = image
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
