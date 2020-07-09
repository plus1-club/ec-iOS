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
    
    @IBOutlet weak var isChecked: UIButton!
    @IBOutlet weak var count: UITextField!
    @IBOutlet weak var product: UILabel!
    @IBOutlet weak var unit: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var multiplicity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
