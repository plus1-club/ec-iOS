//
//  NepodtvViewController.swift
//  ecelectric
//
//  Created by Sam on 18/08/2019.
//  Copyright © 2019 Samir Azizov. All rights reserved.
//

import UIKit

class NepodtvViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var nepodtvTableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
//    let invoiceNumberNepodtv = [("Счет № 756503 от 27 марта 2019"), ("Счет № 75358 от 27 марта 2019"), ("Счет № 737303 от 27 марта 2019"), ("Счет № 736947 от 27 марта 2019"), ("Счет № 758673 от 27 марта 2019")]
//    let invoiceAmountNepodtv = [("Сумма: 7 970,98"), ("Сумма: 6 172,76"), ("Сумма: 8 817,87"), ("Сумма: 27 967,00"), ("Сумма: 356,73")]
    var invoices = [Invoice]()
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nepodtvTableView.delegate = self
        nepodtvTableView.dataSource = self
        nepodtvTableView.tableFooterView = UIView()

        refreshControl.attributedTitle = NSAttributedString(string: "Потяните, чтобы обновить")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        nepodtvTableView.addSubview(refreshControl) // not required when using UITableViewController
        
        sideMenu()
        
        getUnconfirmedOrders()
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
        getUnconfirmedOrders()
    }
    
    //MARK: IBActions
    @IBAction func showInvoiceDetailsTapped(_ sender: UIButton) {
        let selectedInvoice = self.invoices[sender.tag]

        let controller = self.storyboard?.instantiateViewController(withIdentifier: "UnconfirmedOrderDetailsViewController") as! UnconfirmedOrderDetailsViewController
        controller.invoice = selectedInvoice
        self.navigationController?.pushViewController(controller, animated: true)

    }
    
    //MARK: API Call
    func getUnconfirmedOrders() {
        Invoice().getUnconfirmedOrders(successBlock: { (invoices) in
            self.invoices = invoices
            self.nepodtvTableView.reloadData()
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
        let nepodtvCell = tableView.dequeueReusableCell(withIdentifier: "unconfirmedOrderCell", for: indexPath) as! NepodtvTableViewCell
        
        let invoice = self.invoices[indexPath.row]
        
        nepodtvCell.invoiceNumber1.text = String(format: "Счет № %@ от %@", arguments: [invoice.number, invoice.date])//self.invoiceNumberNepodtv[indexPath.row]
        nepodtvCell.invoiceAmount1.text = String(format: "Сумма: %@ pyб.", arguments: [invoice.sum])//self.invoiceAmountNepodtv[indexPath.row]
        
        nepodtvCell.invoiceDetailsButton.tag = indexPath.row
        nepodtvCell.invoiceDetailsButton.removeTarget(self, action: #selector(showInvoiceDetailsTapped(_:)), for: .touchUpInside)
        nepodtvCell.invoiceDetailsButton.addTarget(self, action: #selector(showInvoiceDetailsTapped(_:)), for: .touchUpInside)

        return nepodtvCell
    }
}
