//
//  CanceledOrderDetailsTableViewCell.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 29/11/19.
//  Copyright © 2019 Samir Azizov. All rights reserved.
//

import UIKit

class CanceledOrderDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var countAndAvailable: UILabel!
    @IBOutlet weak var price: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
