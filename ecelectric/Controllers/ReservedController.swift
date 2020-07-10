//
//  ReservedController.swift
//  EC-online
//
//  Created by Samir Azizov on 11/09/2019.
//  Refactored by Sergey Lavrov on 16/06/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import UIKit

class ReservedController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: - Outlet
    @IBOutlet weak var reservedTableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    //MARK: - Variable
    var invoices = [Invoice]()
    var refreshControl = UIRefreshControl()

    //MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reservedTableView.delegate = self
        reservedTableView.dataSource = self
        reservedTableView.tableFooterView = UIView()

        Utilities.sideMenu(window: self, menuButton: menuButton)

        refreshControl.attributedTitle = NSAttributedString(string: "Потяните, чтобы обновить")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        reservedTableView.addSubview(refreshControl) // not required when using UITableViewController

        getReservedItemList(isShowLoader: true)
    }
    
    //MARK: - Selector
    @objc func refresh(sender:AnyObject) {
       // Code to refresh table view
        getReservedItemList(isShowLoader: false)
    }
    
    //MARK: - Action
    @IBAction func showInvoiceDetailsTapped(_ sender: UIButton) {
        let selectedInvoice = self.invoices[sender.tag]

        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ReservedDetailsController") as! ReservedDetailsController
        controller.invoice = selectedInvoice
        self.navigationController?.pushViewController(controller, animated: true)

    }
    
    @IBAction func printInvoiceTapped(_ sender: UIButton) {
        let selectedInvoice = self.invoices[sender.tag]

        Details().getInvoicePrint(accountNo: selectedInvoice.number, successBlock: { (fileURL) in
            
            let controller = PrintController()
            controller.pdfFilePath = fileURL
            controller.number = selectedInvoice.number
            self.navigationController?.pushViewController(controller, animated: true)

            
        }) { (error) in
            Utilities.tableMessage(table: self.reservedTableView, refresh: self.refreshControl, message: error)
        }

    }
    
    //MARK: - API
    func getReservedItemList(isShowLoader: Bool) {
        Invoice().getReservedList(isShowLoader: isShowLoader, successBlock: { (invoices) in
            
            self.invoices = invoices
            self.reservedTableView.reloadData()
            self.refreshControl.endRefreshing()
            
        }) { (error) in
            Utilities.tableMessage(table: self.reservedTableView, refresh: self.refreshControl, message: error)
        }
    }
    
    //MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reservedCell = tableView.dequeueReusableCell(withIdentifier: "reservedCell", for: indexPath as IndexPath) as! ReservedView
        let invoice = self.invoices[indexPath.row]
        
        reservedCell.invoiceNumber1.text = String(format: "Счет № %@ от %@", arguments: [invoice.number, invoice.date])//self.invoiceNumberNepodtv[indexPath.row]
        reservedCell.invoiceAmount1.text = String(format: "Сумма: %@ pyб.", arguments: [invoice.sum])//self.invoiceAmountNepodtv[indexPath.row]
        
        reservedCell.invoiceDetailsButton.tag = indexPath.row
        reservedCell.invoiceDetailsButton.removeTarget(self, action: #selector(showInvoiceDetailsTapped(_:)), for: .touchUpInside)
        reservedCell.invoiceDetailsButton.addTarget(self, action: #selector(showInvoiceDetailsTapped(_:)), for: .touchUpInside)

        reservedCell.scoreButton.tag = indexPath.row
        reservedCell.scoreButton.removeTarget(self, action: #selector(printInvoiceTapped(_:)), for: .touchUpInside)
        reservedCell.scoreButton.addTarget(self, action: #selector(printInvoiceTapped(_:)), for: .touchUpInside)

        return reservedCell
    }
}
