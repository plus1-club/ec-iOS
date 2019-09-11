//
//  SegmentedViewController.swift
//  ecelectric
//
//  Created by Sam on 05/09/2019.
//  Copyright © 2019 Samir Azizov. All rights reserved.
//

import UIKit

class checkByRequestViewController: UIViewController {

    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sideMenu()
    }
    
    func sideMenu() {
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            revealViewController().rightViewRevealWidth = 275
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    @IBAction func switchViews(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            firstView.alpha = 1
            secondView.alpha = 0
        } else {
            firstView.alpha = 0
            secondView.alpha = 1
        }
    }

}
