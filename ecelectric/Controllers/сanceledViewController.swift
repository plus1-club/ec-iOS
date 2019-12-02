//
//  сanceledViewController.swift
//  ecelectric
//
//  Created by Sam on 11/09/2019.
//  Copyright © 2019 Samir Azizov. All rights reserved.
//

import UIKit

class canceledViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    

    @IBOutlet weak var canceledTableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var canceledOrders = [Invoice]()
    var refreshControl = UIRefreshControl()

//    let invoiceNumber1 = [("Счет № 756503 от 27 марта 2019"), ("Счет № 75358 от 27 марта 2019"), ("Счет № 737303 от 27 марта 2019"), ("Счет № 736947 от 27 марта 2019"), ("Счет № 758673 от 27 марта 2019")]
//    let invoiceAmount1 = [("Сумма: 7 970,98"), ("Сумма: 6 172,76"), ("Сумма: 8 817,87"), ("Сумма: 27 967,00"), ("Сумма: 356,73")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        canceledTableView.delegate = self
        canceledTableView.dataSource = self
        canceledTableView.tableFooterView = UIView()

        sideMenu()
        
        getCancelledOrders()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Потяните, чтобы обновить")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        canceledTableView.addSubview(refreshControl) // not required when using UITableViewController

    }
    
    func sideMenu() {
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            revealViewController().rightViewRevealWidth = 275
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    //MARK: Refresh Data
    @objc func refresh(sender:AnyObject) {
       // Code to refresh table view
        getCancelledOrders()
    }
    
    //MARK: API Call
    func getCancelledOrders() {
        Invoice().getUnconfirmedOrders(successBlock: { (invoices) in
            self.canceledOrders = invoices
            self.canceledTableView.reloadData()
            self.refreshControl.endRefreshing()

        }) { (error) in
            Utilities.showAlert(strTitle: error, strMessage: nil, parent: self, OKButtonTitle: nil, CancelButtonTitle: nil, okBlock: nil, cancelBlock: nil)
            self.refreshControl.endRefreshing()

        }
    }
    
    //MARK: IBActions
    @IBAction func showInvoiceDetailsTapped(_ sender: UIButton) {
        let selectedInvoice = self.canceledOrders[sender.tag]

        let controller = self.storyboard?.instantiateViewController(withIdentifier: "CanceledOrderDetailsViewController") as! CanceledOrderDetailsViewController
        controller.invoice = selectedInvoice
        self.navigationController?.pushViewController(controller, animated: true)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return canceledOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let canceledCell = tableView.dequeueReusableCell(withIdentifier: "canceledCell", for: indexPath as IndexPath) as! canceledTableViewCell
        
        let canceledOrder = self.canceledOrders[indexPath.row]

        canceledCell.invoiceNumber1.text = String(format: "Счет № %@ от %@", arguments: [canceledOrder.number, canceledOrder.date])
        canceledCell.invoiceAmount1.text = String(format: "Сумма: %@ pyб.", arguments: [canceledOrder.sum])
        
        canceledCell.invoiceDetailsButton.tag = indexPath.row
        canceledCell.invoiceDetailsButton.removeTarget(self, action: #selector(showInvoiceDetailsTapped(_:)), for: .touchUpInside)
        canceledCell.invoiceDetailsButton.addTarget(self, action: #selector(showInvoiceDetailsTapped(_:)), for: .touchUpInside)

        return canceledCell
}

}
