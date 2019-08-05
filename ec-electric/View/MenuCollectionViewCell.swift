//
//  MenuCollectionViewCell.swift
//  ec-electric
//
//  Created by Sam on 05/08/2019.
//  Copyright © 2019 +1. All rights reserved.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var menu: Menu? {
        didSet {
            nameLabel.text = menu?.name
            if let image = menu?.imageName {
                imageView.image = UIImage(named: image)
            }
        }
    }
    
    
    
}
