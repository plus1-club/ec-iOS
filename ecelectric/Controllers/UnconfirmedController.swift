//
//  UnconfirmedController.swift
//  EC-online
//
//  Created by Samir Azizov on 18/08/2019.
//  Updated by Sergey Lavrov on 02/04/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import UIKit

class UnconfirmedController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var nepodtvTableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
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
        
        Utilities.sideMenu(window: self, menuButton: menuButton)

        getUnconfirmedOrders(isShowLoader: true)
    }
        
    @objc func refresh(sender:AnyObject) {
       // Code to refresh table view
        getUnconfirmedOrders(isShowLoader: false)
    }
    
    //MARK: - IBActions
    @IBAction func showInvoiceDetailsTapped(_ sender: UIButton) {
        let selectedInvoice = self.invoices[sender.tag]

        let controller = self.storyboard?.instantiateViewController(withIdentifier: "UnconfirmedDetailsController") as! UnconfirmedDetailsController
        controller.invoice = selectedInvoice
        self.navigationController?.pushViewController(controller, animated: true)

    }
    
    //MARK: - API Call
    func getUnconfirmedOrders(isShowLoader: Bool) {
        Invoice().getUnconfirmedOrders(isShowLoader: isShowLoader, successBlock: { (invoices) in
            self.invoices = invoices
            self.nepodtvTableView.reloadData()
            self.refreshControl.endRefreshing()
        }) { (error) in
            //Utilities.showAlert(strTitle: error, strMessage: nil, parent: self, OKButtonTitle: nil, CancelButtonTitle: nil, okBlock: nil, cancelBlock: nil)
            let messageLabel = UILabel(frame: CGRect(x:0, y:0, width: self.nepodtvTableView.bounds.size.width, height: self.nepodtvTableView.bounds.size.height))
            messageLabel.text = error
            messageLabel.textColor = .black
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.sizeToFit()
            self.nepodtvTableView.backgroundView = messageLabel;
            self.refreshControl.endRefreshing()
        }
    }
    
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
