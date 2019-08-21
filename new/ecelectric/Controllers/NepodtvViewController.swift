//
//  NepodtvViewController.swift
//  ecelectric
//
//  Created by Sam on 18/08/2019.
//  Copyright © 2019 Samir Azizov. All rights reserved.
//

import UIKit

class NepodtvViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var nepodtvTableView: UITableView!
    
    
    let invoiceNumberNepodtv = [("Счет № 756503 от 27 марта 2019"), ("Счет № 75358 от 27 марта 2019"), ("Счет № 737303 от 27 марта 2019"), ("Счет № 736947 от 27 марта 2019"), ("Счет № 758673 от 27 марта 2019")]
    let invoiceAmountNepodtv = [("Сумма: 7 970,98"), ("Сумма: 6 172,76"), ("Сумма: 8 817,87"), ("Сумма: 27 967,00"), ("Сумма: 356,73")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nepodtvTableView.delegate = self
        nepodtvTableView.dataSource = self
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoiceNumberNepodtv.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nepodtvCell = tableView.dequeueReusableCell(withIdentifier: "nepodtvCell", for: indexPath as IndexPath) as! NepodtvTableViewCell
        nepodtvCell.invoiceNumber1.text = self.invoiceNumberNepodtv[indexPath.row]
        nepodtvCell.invoiceAmount1.text = self.invoiceAmountNepodtv[indexPath.row]
        
        
        return nepodtvCell
    }
}
