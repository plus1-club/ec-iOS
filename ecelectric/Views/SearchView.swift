//
//  SearchView.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 29/11/19.
//  Updated by Sergey Lavrov on 02/04/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import UIKit

class SearchView: UITableViewCell {

    static let cellIdentifier = "search"
    
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
