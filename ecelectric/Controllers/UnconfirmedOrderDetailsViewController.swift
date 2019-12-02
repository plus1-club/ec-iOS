//
//  UnconfirmedOrderDetailsViewController.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 29/11/19.
//  Copyright © 2019 Samir Azizov. All rights reserved.
//

import UIKit

class UnconfirmedOrderDetailsViewController: UIViewController {

    @IBOutlet weak var orderDetailsTableView: UITableView!
    @IBOutlet weak var accountNoAndDate: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    
    var invoiceDetails = [InvoiceDetails]()
    var invoice : Invoice!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.orderDetailsTableView.tableFooterView = UIView()

        getUnconfirmedOrderDetails()
        // Do any additional setup after loading the view.
    }
    
    //MARK: API Call
    func getUnconfirmedOrderDetails() {
        InvoiceDetails().getUnconfirmedOrderDetails(accountNo: invoice.number, successBlock: { (invoices) in
            
            self.accountNoAndDate.text = String(format: "Счет № %@ от %@", arguments: [self.invoice.number, self.invoice.date])
            self.totalAmount.text = String(format: "Итого: %@ pyб.", arguments: [self.invoice.sum])
            
            self.invoiceDetails = invoices
            self.orderDetailsTableView.reloadData()

        }) { (error) in
            Utilities.showAlert(strTitle: error, strMessage: nil, parent: self, OKButtonTitle: nil, CancelButtonTitle: nil, okBlock: nil, cancelBlock: nil)
        }
    }
 
    //MARK: IBActions
    @IBAction func backTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension UnconfirmedOrderDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.invoiceDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "unconfirmedItemDetailsCell", for: indexPath) as! UnconfirmedOrderDetailsTableViewCell
        
        let invoice = self.invoiceDetails[indexPath.row]
        
        cell.productName.text = invoice.product
        cell.countAndAvailable.text = String(format: "%@     %@", arguments: [invoice.id, invoice.available])
        cell.price.text = String(format: "%@ pyб.", arguments: [invoice.price])
        
        return cell
    }
}
