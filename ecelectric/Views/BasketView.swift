//
//  BasketView.swift
//  EC-online
//
//  Created by Samir Azizov on 11/09/2019.
//  Updated by Sergey Lavrov on 02/04/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import UIKit

class BasketView: UITableViewCell {

    @IBOutlet weak var invoiceNumber1: UILabel!
    @IBOutlet weak var invoiceAmount1: UILabel!
    @IBOutlet weak var itemPrice1: UILabel!
    @IBOutlet weak var qty: UITextField!
    @IBOutlet weak var unit: UILabel!
    
    @IBOutlet weak var circleIcon: UILabel!
    @IBOutlet weak var deleteItem: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        circleIcon.layer.cornerRadius = circleIcon.frame.width/2
        circleIcon.layer.masksToBounds = true
        //circleIcon.backgroundColor = UIColor.red
        circleIcon.textColor = UIColor.red
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
