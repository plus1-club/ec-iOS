//
//  OrderViewController.swift
//  ecelectirc
//
//  Created by Sam on 13/08/2019.
//  Copyright © 2019 Samir Azizov. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var orderTableView: UITableView!
    
    let invoiceNumber1 = [("Счет № 756503 от 27 марта 2019"), ("Счет № 75358 от 27 марта 2019"), ("Счет № 737303 от 27 марта 2019"), ("Счет № 736947 от 27 марта 2019"), ("Счет № 758673 от 27 марта 2019")]
    let invoiceAmount1 = [("Сумма: 7 970,98"), ("Сумма: 6 172,76"), ("Сумма: 8 817,87"), ("Сумма: 27 967,00"), ("Сумма: 356,73")]
    let invoiceStatus1 = [("аннулирован"), ("аннулирован"), ("аннулирован"), ("аннулирован"), ("аннулирован")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderTableView.delegate = self
        orderTableView.dataSource = self
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoiceNumber1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderCell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath as IndexPath) as! OrderTableViewCell
        orderCell.invoiceNumber1.text = self.invoiceNumber1[indexPath.row]
        orderCell.invoiceAmount1.text = self.invoiceAmount1[indexPath.row]
        orderCell.inoviceStatus1.text = self.invoiceStatus1[indexPath.row]
        
        return orderCell
    }
}
