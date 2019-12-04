//
//  shippedViewController.swift
//  ecelectric
//
//  Created by Sam on 11/09/2019.
//  Copyright © 2019 Samir Azizov. All rights reserved.
//

import UIKit

class shippedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var shippedTableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var invoices = [Invoice]()
    var refreshControl = UIRefreshControl()

//    let invoiceNumber1 = [("Счет № 756503 от 27 марта 2019"), ("Счет № 75358 от 27 марта 2019"), ("Счет № 737303 от 27 марта 2019"), ("Счет № 736947 от 27 марта 2019"), ("Счет № 758673 от 27 марта 2019")]
//    let invoiceAmount1 = [("Сумма: 7 970,98"), ("Сумма: 6 172,76"), ("Сумма: 8 817,87"), ("Сумма: 27 967,00"), ("Сумма: 356,73")]
//    let waybillNumber1 = [("Накладная №39727"), ("Накладная №34637"), ("Накладная №53271"), ("Накладная №87365"), ("Накладная №12836")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shippedTableView.delegate = self
        shippedTableView.dataSource = self
        shippedTableView.tableFooterView = UIView()
        
        sideMenu()
        
        
        getShippedOrders(isShowLoader: true)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Потяните, чтобы обновить")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        shippedTableView.addSubview(refreshControl) // not required when using UITableViewController

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
        getShippedOrders(isShowLoader: false)
    }
    
    //MARK: API Call
    func getShippedOrders(isShowLoader: Bool) {
        Invoice().getShippedItemList(isShowLoader: isShowLoader, successBlock: { (invoices) in
            self.invoices = invoices
            self.shippedTableView.reloadData()
            self.refreshControl.endRefreshing()
                                                                    		
        }) { (error) in
            Utilities.showAlert(strTitle: error, strMessage: nil, parent: self, OKButtonTitle: nil, CancelButtonTitle: nil, okBlock: nil, cancelBlock: nil)
            self.refreshControl.endRefreshing()

        }
    }
    
    //MARK: IBActions
    @IBAction func showInvoiceDetailsTapped(_ sender: UIButton) {
        let selectedInvoice = self.invoices[sender.tag]

        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ShippedOrderDetailsViewController") as! ShippedOrderDetailsViewController
        controller.invoice = selectedInvoice
        self.navigationController?.pushViewController(controller, animated: true)

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let shippedCell = tableView.dequeueReusableCell(withIdentifier: "shippedCell", for: indexPath as IndexPath) as! shippedTableViewCell
        
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
