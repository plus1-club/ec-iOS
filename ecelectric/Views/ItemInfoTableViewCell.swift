//
//  ItemInfoTableViewCell.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 29/11/19.
//  Copyright © 2019 Samir Azizov. All rights reserved.
//

import UIKit

class ItemInfoTableViewCell: UITableViewCell {

    static let cellIdentifier = "itemsTableCell"
    
    @IBOutlet weak var isSelectedItem: UIButton!
    @IBOutlet weak var qty: UITextField!
    @IBOutlet weak var stockStatus: UILabel!
    @IBOutlet weak var productName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
