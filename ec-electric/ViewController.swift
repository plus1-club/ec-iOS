//
//  ViewController.swift
//  ec-electric
//
//  Created by Sergey Lavrov on 31.07.2019.
//  Copyright © 2019 +1. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var round_button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        round_button.layer.cornerRadius = 5.0
        round_button.layer.masksToBounds = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }


}

