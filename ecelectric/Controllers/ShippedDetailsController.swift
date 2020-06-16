//
//  ShippedDetailsController.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 04/12/19.
//  Refactored by Sergey Lavrov on 16/06/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import UIKit

class ShippedDetailsController: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var accountNoAndDate: UILabel!
    @IBOutlet weak var wayBillsNo: UILabel!
    @IBOutlet weak var totalAmount: UILabel!

    //MARK: - Variable
    var invoiceDetails = [Details]()
    var invoice : Invoice!
    var refreshControl = UIRefreshControl()

    //MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        setToInitialValue()
        detailsTableView.tableFooterView = UIView()
        getShippedItemDetails()

        refreshControl.attributedTitle = NSAttributedString(string: "Потяните, чтобы обновить")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        detailsTableView.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    //MARK: - Selector
    @objc func refresh(sender:AnyObject) {
       getShippedItemDetails()
    }
    
    //MARK: - API
    func getShippedItemDetails() {
        Details().getShippedItemDetails(accountNo: invoice.number, successBlock: { (invoices) in
            
            self.accountNoAndDate.text = String(format: "Счет № %@ от %@", arguments: [self.invoice.number, self.invoice.date])
            self.wayBillsNo.text = String(format: "Накладная № %@", arguments: [self.invoice.waybill])
            self.totalAmount.text = String(format: "Итого: %@ pyб.", arguments: [self.invoice.sum])
            
            self.invoiceDetails = invoices
            self.detailsTableView.reloadData()
            self.refreshControl.endRefreshing()

        }) { (error) in
            Utilities.tableMessage(table: self.detailsTableView, refresh: self.refreshControl, message: error)
        }
    }
    
    //MARK: - Method
    func setToInitialValue() {
        self.accountNoAndDate.text = ""
        self.wayBillsNo.text = ""
        self.totalAmount.text = ""
    }

    //MARK: - Action
    @IBAction func backTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - DataSource
extension ShippedDetailsController: UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.invoiceDetails.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "shippedDetailsCell", for: indexPath) as! ShippedDetailsView
       
       let invoice = self.invoiceDetails[indexPath.row]
       
       cell.productName.text = invoice.product
       cell.countAndAvailable.text = String(format: "%@     %@", arguments: [invoice.count, invoice.available])
       cell.price.text = String(format: "%@ pyб.", arguments: [invoice.price])
       
       return cell
   }
}
