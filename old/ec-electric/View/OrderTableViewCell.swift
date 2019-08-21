//
//  OrderTableViewCell.swift
//  ec-electric
//
//  Created by Sam on 09/08/2019.
//  Copyright © 2019 +1. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var invoiceNumber: UILabel!
    @IBOutlet weak var invoiceAmount: UILabel!
    @IBOutlet weak var invoiceStatus: UILabel!
    @IBAction func invoice(_ sender: Any) {
    }
    @IBAction func invoiceDetails(_ sender: Any) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
