//
//  ShippedController.swift
//  EC-online
//
//  Created by Samir Azizov on 11/09/2019.
//  Refactored by Sergey Lavrov on 16/06/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import UIKit

class ShippedController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: - Outlet
    @IBOutlet weak var shippedTableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    //MARK: - Variable
    var invoices = [Invoice]()
    var refreshControl = UIRefreshControl()

    //MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shippedTableView.delegate = self
        shippedTableView.dataSource = self
        shippedTableView.tableFooterView = UIView()
        
        Utilities.sideMenu(window: self, menuButton: menuButton)

        getShippedOrders()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Потяните, чтобы обновить")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        shippedTableView.addSubview(refreshControl) // not required when using UITableViewController
    }
        
    //MARK: - Selector
    @objc func refresh(sender:AnyObject) {
       // Code to refresh table view
        getShippedOrders()
    }
    
    //MARK: - API
    func getShippedOrders() {
        Utilities.tableMessage(table: self.shippedTableView, refresh: self.refreshControl, message: "")
        refreshControl.beginRefreshing()
        Invoice().getShippedList(
            successBlock: { (invoices) in
                self.invoices = invoices
                self.shippedTableView.reloadData()
                self.refreshControl.endRefreshing()
            },
            errorBlock: { (error) in
                self.invoices.removeAll()
                self.shippedTableView.reloadData()
                self.refreshControl.endRefreshing()
                Utilities.tableMessage(table: self.shippedTableView, refresh: self.refreshControl, message: error)
            }
        )
    }
    
    //MARK: - Action
    @IBAction func showInvoiceDetailsTapped(_ sender: UIButton) {
        let selectedInvoice = self.invoices[sender.tag]

        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ShippedDetailsController") as! ShippedDetailsController
        controller.invoice = selectedInvoice
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let shippedCell = tableView.dequeueReusableCell(withIdentifier: "shippedCell", for: indexPath as IndexPath) as! ShippedView
        
        let invoice = invoices[indexPath.row]
        shippedCell.invoiceNumber1.text = String(format: "Счет № %@ от %@", arguments: [invoice.number, invoice.date])
        shippedCell.invoiceAmount1.text = String(format: "Сумма: %@ pyб.", arguments: [invoice.sum])
        shippedCell.waybillNumber1.text = String(format: "Накладная № %@", arguments: [invoice.waybill])
        
        shippedCell.invoiceDetailsButton.tag = indexPath.row
        shippedCell.invoiceDetailsButton.removeTarget(self, action: #selector(showInvoiceDetailsTapped(_:)), for: .touchUpInside)
        shippedCell.invoiceDetailsButton.addTarget(self, action: #selector(showInvoiceDetailsTapped(_:)), for: .touchUpInside)

        return shippedCell
    }
}
