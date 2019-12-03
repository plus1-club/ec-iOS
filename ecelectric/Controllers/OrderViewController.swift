//
//  OrderViewController.swift
//  ecelectirc
//
//  Created by Sam on 13/08/2019.
//  Copyright © 2019 Samir Azizov. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var orderTableView: UITableView!
    
    
    var invoices = [Invoice]()
    var refreshControl = UIRefreshControl()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderTableView.delegate = self
        orderTableView.dataSource = self
        orderTableView.tableFooterView = UIView()

        sideMenu()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Потяните, чтобы обновить")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        orderTableView.addSubview(refreshControl) // not required when using UITableViewController

        getOrderedItemList(isShowLoader: true)
    }
    
    func sideMenu() {
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            revealViewController().rightViewRevealWidth = 275
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    @objc func refresh(sender:AnyObject) {
       // Code to refresh table view
        getOrderedItemList(isShowLoader: false)
    }
    
    //MARK: IBActions
    @IBAction func showInvoiceDetailsTapped(_ sender: UIButton) {
        let selectedInvoice = self.invoices[sender.tag]

        let controller = self.storyboard?.instantiateViewController(withIdentifier: "orderDetailsViewController") as! orderDetailsViewController
        controller.invoice = selectedInvoice
        self.navigationController?.pushViewController(controller, animated: true)

    }
    
    @IBAction func printInvoiceTapped(_ sender: UIButton) {
        let selectedInvoice = self.invoices[sender.tag]

        Invoice().getInvoicePrint(accountNo: selectedInvoice.number, successBlock: { (fileURL) in
            
            let controller = ViewPDFViewController()
            controller.pdfFilePath = fileURL
            self.navigationController?.pushViewController(controller, animated: true)

            
        }) { (error) in
            Utilities.showAlert(strTitle: error, strMessage: nil, parent: self, OKButtonTitle: nil, CancelButtonTitle: nil, okBlock: nil, cancelBlock: nil)
        }

    }
    
    //MARK: API Call
    func getOrderedItemList(isShowLoader: Bool) {
        Invoice().getOrderedItemList(isShowLoader: isShowLoader, successBlock: { (invoices) in
            
            self.invoices = invoices
            self.orderTableView.reloadData()
            self.refreshControl.endRefreshing()
            
        }) { (error) in
            Utilities.showAlert(strTitle: error, strMessage: nil, parent: self, OKButtonTitle: nil, CancelButtonTitle: nil, okBlock: nil, cancelBlock: nil)
            self.refreshControl.endRefreshing()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.invoices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderCell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath as IndexPath) as! OrderTableViewCell
    
        let invoice = self.invoices[indexPath.row]
        
        orderCell.invoiceNumber1.text = String(format: "Счет № %@ от %@", arguments: [invoice.number, invoice.date])//self.invoiceNumberNepodtv[indexPath.row]
        orderCell.invoiceAmount1.text = String(format: "Сумма: %@ pyб.", arguments: [invoice.sum])//self.invoiceAmountNepodtv[indexPath.row]
        
        orderCell.invoiceDetailsButton.tag = indexPath.row
        orderCell.invoiceDetailsButton.removeTarget(self, action: #selector(showInvoiceDetailsTapped(_:)), for: .touchUpInside)
        orderCell.invoiceDetailsButton.addTarget(self, action: #selector(showInvoiceDetailsTapped(_:)), for: .touchUpInside)
        
        orderCell.scoreButton.tag = indexPath.row
        orderCell.scoreButton.removeTarget(self, action: #selector(printInvoiceTapped(_:)), for: .touchUpInside)
        orderCell.scoreButton.addTarget(self, action: #selector(printInvoiceTapped(_:)), for: .touchUpInside)
        
        return orderCell
    }
}
