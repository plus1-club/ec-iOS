//
//  ShippedOrderDetailsViewController.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 04/12/19.
//  Copyright © 2019 Samir Azizov. All rights reserved.
//

import UIKit

class ShippedOrderDetailsViewController: UIViewController {

    @IBOutlet weak var orderDetailsTableView: UITableView!
    @IBOutlet weak var accountNoAndDate: UILabel!
    @IBOutlet weak var wayBillsNo: UILabel!
    @IBOutlet weak var totalAmount: UILabel!

    var invoiceDetails = [InvoiceDetails]()
    var invoice : Invoice!

    override func viewDidLoad() {
        super.viewDidLoad()

        setToInitialValue()

        orderDetailsTableView.tableFooterView = UIView()

        getShippedItemDetails()

    }
    
    func setToInitialValue() {
        self.accountNoAndDate.text = ""
        self.wayBillsNo.text = ""
        self.totalAmount.text = ""
    }
    
    //MARK: API Call
    func getShippedItemDetails() {
        InvoiceDetails().getShippedItemDetails(accountNo: invoice.number, successBlock: { (invoices) in
            
            self.accountNoAndDate.text = String(format: "Счет № %@ от %@", arguments: [self.invoice.number, self.invoice.date])
            self.wayBillsNo.text = String(format: "Накладная № %@", arguments: [self.invoice.waybill])
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

extension ShippedOrderDetailsViewController: UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.invoiceDetails.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "shippedItemDetailsCell", for: indexPath) as! ShippedOrderDetailsTableViewCell
       
       let invoice = self.invoiceDetails[indexPath.row]
       
       cell.productName.text = invoice.product
       cell.countAndAvailable.text = String(format: "%@     %@", arguments: [invoice.count, invoice.available])
       cell.price.text = String(format: "%@ pyб.", arguments: [invoice.price])
       
       return cell
   }
}
