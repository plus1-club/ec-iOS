//
//  ShippedOrderDetailsTableViewCell.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 04/12/19.
//  Copyright © 2019 Samir Azizov. All rights reserved.
//

import UIKit

class ShippedOrderDetailsTableViewCell: UITableViewCell {

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
