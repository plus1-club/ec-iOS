//
//  reservedTableViewCell.swift
//  ecelectric
//
//  Created by Sam on 11/09/2019.
//  Copyright © 2019 Samir Azizov. All rights reserved.
//

import UIKit

class reservedTableViewCell: UITableViewCell {

    @IBOutlet weak var invoiceNumber1: UILabel!
    @IBOutlet weak var invoiceAmount1: UILabel!
    @IBOutlet weak var invoiceDetailsButton: Button!
    @IBOutlet weak var scoreButton: Button!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
