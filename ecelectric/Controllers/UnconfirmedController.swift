//
//  UnconfirmedController.swift
//  EC-online
//
//  Created by Samir Azizov on 18/08/2019.
//  Refactored by Sergey Lavrov on 16/06/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import UIKit

class UnconfirmedController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    //MARK: - Outlet
    @IBOutlet weak var unconfirmedTableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    //MARK: - Variable
    var invoices = [Invoice]()
    var refreshControl = UIRefreshControl()

    //MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        unconfirmedTableView.delegate = self
        unconfirmedTableView.dataSource = self
        unconfirmedTableView.tableFooterView = UIView()

        refreshControl.attributedTitle = NSAttributedString(string: "Потяните, чтобы обновить")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        unconfirmedTableView.addSubview(refreshControl) // not required when using UITableViewController
        
        Utilities.sideMenu(window: self, menuButton: menuButton)

        getUnconfirmedOrders(isShowLoader: true)
    }
        
    //MARK: - Selector
    @objc func refresh(sender:AnyObject) {
       // Code to refresh table view
        getUnconfirmedOrders(isShowLoader: false)
    }
    
    //MARK: - Action
    @IBAction func showInvoiceDetailsTapped(_ sender: UIButton) {
        let selectedInvoice = self.invoices[sender.tag]
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "UnconfirmedDetailsController") as! UnconfirmedDetailsController
        controller.invoice = selectedInvoice
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - API
    func getUnconfirmedOrders(isShowLoader: Bool) {
        Invoice().getUnconfirmedList(isShowLoader: isShowLoader, successBlock: { (invoices) in
            self.invoices = invoices
            self.unconfirmedTableView.reloadData()
            self.refreshControl.endRefreshing()
        }) { (error) in
            Utilities.tableMessage(table: self.unconfirmedTableView, refresh: self.refreshControl, message: error)
        }
    }
    
    //MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.invoices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let unconfirmedCell = tableView.dequeueReusableCell(withIdentifier: "unconfirmedCell", for: indexPath) as! UnconfirmedView
        
        let invoice = self.invoices[indexPath.row]
        
        unconfirmedCell.invoiceNumber1.text = String(format: "Счет № %@ от %@", arguments: [invoice.number, invoice.date])//self.invoiceNumberNepodtv[indexPath.row]
        unconfirmedCell.invoiceAmount1.text = String(format: "Сумма: %@ pyб.", arguments: [invoice.sum])//self.invoiceAmountNepodtv[indexPath.row]
        
        unconfirmedCell.invoiceDetailsButton.tag = indexPath.row
        unconfirmedCell.invoiceDetailsButton.removeTarget(self, action: #selector(showInvoiceDetailsTapped(_:)), for: .touchUpInside)
        unconfirmedCell.invoiceDetailsButton.addTarget(self, action: #selector(showInvoiceDetailsTapped(_:)), for: .touchUpInside)

        return unconfirmedCell
    }
}
