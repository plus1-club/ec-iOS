//
//  reservedViewController.swift
//  ecelectric
//
//  Created by Sam on 11/09/2019.
//  Copyright © 2019 Samir Azizov. All rights reserved.
//

import UIKit

class reservedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var reservedTableView: UITableView!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    let invoiceNumber1 = [("Счет № 756503 от 27 марта 2019"), ("Счет № 75358 от 27 марта 2019"), ("Счет № 737303 от 27 марта 2019"), ("Счет № 736947 от 27 марта 2019"), ("Счет № 758673 от 27 марта 2019")]
    let invoiceAmount1 = [("Сумма: 7 970,98"), ("Сумма: 6 172,76"), ("Сумма: 8 817,87"), ("Сумма: 27 967,00"), ("Сумма: 356,73")]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reservedTableView.delegate = self
        reservedTableView.dataSource = self
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoiceNumber1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reservedCell = tableView.dequeueReusableCell(withIdentifier: "reservedCell", for: indexPath as IndexPath) as! reservedTableViewCell
        reservedCell.invoiceNumber1.text = self.invoiceNumber1[indexPath.row]
        reservedCell.invoiceAmount1.text = self.invoiceAmount1[indexPath.row]
    
        
        return reservedCell
    }
}