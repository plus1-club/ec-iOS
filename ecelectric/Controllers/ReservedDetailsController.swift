//
//  ReservedDetailsController.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 03/12/19.
//  Updated by Sergey Lavrov on 02/04/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import UIKit

class ReservedDetailsController: UIViewController {

    @IBOutlet weak var orderDetailsTableView: UITableView!
    @IBOutlet weak var accountNoAndDate: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    
    var invoiceDetails = [Details]()
    var invoice : Invoice!

    override func viewDidLoad() {
        super.viewDidLoad()

        setToInitialValue()

        orderDetailsTableView.tableFooterView = UIView()

        getReservedItemDetails()
    }
    
    func setToInitialValue() {
        self.accountNoAndDate.text = ""
        self.totalAmount.text = ""
    }
    
    //MARK: API Call
    func getReservedItemDetails() {
        Details().getReservedItemDetails(accountNo: invoice.number, successBlock: { (invoices) in
            
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

extension ReservedDetailsController: UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.invoiceDetails.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "reservedDetailsCell", for: indexPath) as! ReservedDetailsView
       
       let invoice = self.invoiceDetails[indexPath.row]
       
       cell.productName.text = invoice.product
       cell.countAndAvailable.text = String(format: "%@     %@", arguments: [invoice.count, invoice.available])
       cell.price.text = String(format: "%@ pyб.", arguments: [invoice.price])
       
       return cell
   }
}
