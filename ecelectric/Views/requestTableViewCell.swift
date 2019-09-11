//
//  requestTableViewCell.swift
//  ecelectric
//
//  Created by Sam on 11/09/2019.
//  Copyright © 2019 Samir Azizov. All rights reserved.
//

import UIKit

class requestTableViewCell: UITableViewCell {

    @IBOutlet weak var invoiceNumber1: UILabel!
    @IBOutlet weak var invoiceAmount1: UILabel!
    @IBOutlet weak var itemPrice1: UILabel!
    
    @IBOutlet weak var circleIcon: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    circleIcon.layer.cornerRadius = circleIcon.frame.width/2
    circleIcon.layer.masksToBounds = true
    circleIcon.backgroundColor = UIColor.red
    circleIcon.textColor = UIColor.white
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
