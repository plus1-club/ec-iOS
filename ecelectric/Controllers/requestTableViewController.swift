//
//  requestTableViewController.swift
//  ecelectric
//
//  Created by Sam on 11/09/2019.
//  Copyright © 2019 Samir Azizov. All rights reserved.
//

import UIKit

class requestTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var requestTableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let invoiceNumber1 = [("1.Schneider MGU5.418.25ZD 2 USB Зарядное устройство, 2.1A, беж"), ("2.Legrand 774420 Розетка 2К+3 нем.ст.VALENA белый"), ("3.Schneider PA16-004D 1ая розетка с заземлением, со штор."), ("4.Legrand 10954 Суппорт/Рамка 4 М Dpl Кр.65"), ("5.Legrand 10954 Суппорт/Рамка 4 М Dpl Кр.65")]
    let invoiceAmount1 = [("Сумма: 7 970,98"), ("Сумма: 6 172,76"), ("Сумма: 8 817,87"), ("Сумма: 27 967,00"), ("Сумма: 356,73")]
    let itemPrice1 = [("Цена: 2141,81"), ("Цена: 151,65"), ("Цена: 159,29"), ("Цена: 162,74"), ("Цена: 162,74")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestTableView.delegate = self
        requestTableView.dataSource = self
        requestTableView.rowHeight = 70
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
        let requestTableCell = tableView.dequeueReusableCell(withIdentifier: "requestTableCell", for: indexPath as IndexPath) as! requestTableViewCell
        requestTableCell.invoiceNumber1.text = self.invoiceNumber1[indexPath.row]
        requestTableCell.invoiceAmount1.text = self.invoiceAmount1[indexPath.row]
        requestTableCell.itemPrice1.text = self.itemPrice1[indexPath.row]
        
        return requestTableCell
    }
}
