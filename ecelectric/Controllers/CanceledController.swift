//
//  CanceledController.swift
//  EC-online
//
//  Created by Samir Azizov on 11/09/2019.
//  Refactored by Sergey Lavrov on 16/06/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import UIKit

class CanceledController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    //MARK: - Outlet
    @IBOutlet weak var canceledTableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    //MARK: - Variable
    var invoices = [Invoice]()
    var refreshControl = UIRefreshControl()
    
    //MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        canceledTableView.delegate = self
        canceledTableView.dataSource = self
        canceledTableView.tableFooterView = UIView()

        Utilities.sideMenu(window: self, menuButton: menuButton)

        getCancelledOrders()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Потяните, чтобы обновить")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        canceledTableView.addSubview(refreshControl) // not required when using UITableViewController
    }
        
    //MARK: - Selector
    @objc func refresh(sender:AnyObject) {
       // Code to refresh table view
        getCancelledOrders()
    }
    
    //MARK: - API
    func getCancelledOrders() {
        Utilities.tableMessage(table: self.canceledTableView, refresh: self.refreshControl, message: "")
        refreshControl.beginRefreshing()
        self.invoices.removeAll()
        Invoice().getCanceledList(
            successBlock: { (invoices) in
                self.invoices = invoices
                self.canceledTableView.reloadData()
                self.refreshControl.endRefreshing()
            },
            errorBlock: { (error) in
                self.canceledTableView.reloadData()
                self.refreshControl.endRefreshing()
                Utilities.tableMessage(table: self.canceledTableView, refresh: self.refreshControl, message: error)
            }
        )
    }
    
    //MARK: - Action
    @IBAction func showInvoiceDetailsTapped(_ sender: UIButton) {
        let selectedInvoice = self.invoices[sender.tag]

        let controller = self.storyboard?.instantiateViewController(withIdentifier: "CanceledDetailsController") as! CanceledDetailsController
        controller.invoice = selectedInvoice
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let canceledCell = tableView.dequeueReusableCell(withIdentifier: "canceledCell", for: indexPath as IndexPath) as! CanceledView
        
        let canceledOrder = self.invoices[indexPath.row]

        canceledCell.invoiceNumber1.text = String(format: "Счет № %@ от %@", arguments: [canceledOrder.number, canceledOrder.date])
        canceledCell.invoiceAmount1.text = String(format: "Сумма: %@ pyб.", arguments: [canceledOrder.sum])
        
        canceledCell.invoiceDetailsButton.tag = indexPath.row
        canceledCell.invoiceDetailsButton.removeTarget(self, action: #selector(showInvoiceDetailsTapped(_:)), for: .touchUpInside)
        canceledCell.invoiceDetailsButton.addTarget(self, action: #selector(showInvoiceDetailsTapped(_:)), for: .touchUpInside)

        return canceledCell
    }
}
