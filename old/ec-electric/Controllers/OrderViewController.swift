//
//  OrderViewController.swift
//  ec-electric
//
//  Created by Sam on 09/08/2019.
//  Copyright © 2019 +1. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var orderTableView: UITableView!
    let invoiceNumber = [("Счет № 756503 от 27 марта 2019"), ("Счет № 75358 от 27 марта 2019"), ("Счет № 737303 от 27 марта 2019"), ("Счет № 736947 от 27 марта 2019"), ("Счет № 758673 от 27 марта 2019")]
    let invoiceAmount = [("Сумма: 7 970,98"), ("Сумма: 6 172,76"), ("Сумма: 8 817,87"), ("Сумма: 27967,00"), ("Сумма: 356,73")]
    let invoiceStatus = [("аннулирован"), ("аннулирован"), ("аннулирован"), ("аннулирован"), ("аннулирован")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderTableView.delegate = self
        orderTableView.dataSource = self
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoiceNumber.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderCell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath as IndexPath) as! OrderTableViewCell
        orderCell.invoiceNumber.text = self.invoiceNumber[indexPath.row]
        orderCell.invoiceAmount.text = self.invoiceAmount[indexPath.row]
        orderCell.invoiceStatus.text = self.invoiceStatus[indexPath.row]
        
        return orderCell
    }
}

