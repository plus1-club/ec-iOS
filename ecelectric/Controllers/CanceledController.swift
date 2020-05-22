//
//  CanceledController.swift
//  EC-online
//
//  Created by Samir Azizov on 11/09/2019.
//  Updated by Sergey Lavrov on 02/04/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import UIKit

class CanceledController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    

    @IBOutlet weak var canceledTableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var canceledOrders = [Invoice]()
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        canceledTableView.delegate = self
        canceledTableView.dataSource = self
        canceledTableView.tableFooterView = UIView()

        sideMenu()
        
        getCancelledOrders(isShowLoader: true)
        
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
        getCancelledOrders(isShowLoader: false)
    }
    
    //MARK: - API Call
    func getCancelledOrders(isShowLoader: Bool) {
        Invoice().getCanceledOrders(isShowLoader: isShowLoader, successBlock: { (invoices) in
            self.canceledOrders = invoices
            self.canceledTableView.reloadData()
            self.refreshControl.endRefreshing()

        }) { (error) in
            //Utilities.showAlert(strTitle: error, strMessage: nil, parent: self, OKButtonTitle: nil, CancelButtonTitle: nil, okBlock: nil, cancelBlock: nil)
            let messageLabel = UILabel(frame: CGRect(x:0, y:0, width: self.canceledTableView.bounds.size.width, height: self.canceledTableView.bounds.size.height))
            messageLabel.text = error
            messageLabel.textColor = .black
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.sizeToFit()
            self.canceledTableView.backgroundView = messageLabel;
            self.refreshControl.endRefreshing()

        }
    }
    
    //MARK: - IBActions
    @IBAction func showInvoiceDetailsTapped(_ sender: UIButton) {
        let selectedInvoice = self.canceledOrders[sender.tag]

        let controller = self.storyboard?.instantiateViewController(withIdentifier: "CanceledDetailsController") as! CanceledDetailsController
        controller.invoice = selectedInvoice
        self.navigationController?.pushViewController(controller, animated: true)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return canceledOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let canceledCell = tableView.dequeueReusableCell(withIdentifier: "canceledCell", for: indexPath as IndexPath) as! CanceledView
        
        let canceledOrder = self.canceledOrders[indexPath.row]

        canceledCell.invoiceNumber1.text = String(format: "Счет № %@ от %@", arguments: [canceledOrder.number, canceledOrder.date])
        canceledCell.invoiceAmount1.text = String(format: "Сумма: %@ pyб.", arguments: [canceledOrder.sum])
        
        canceledCell.invoiceDetailsButton.tag = indexPath.row
        canceledCell.invoiceDetailsButton.removeTarget(self, action: #selector(showInvoiceDetailsTapped(_:)), for: .touchUpInside)
        canceledCell.invoiceDetailsButton.addTarget(self, action: #selector(showInvoiceDetailsTapped(_:)), for: .touchUpInside)

        return canceledCell
}

}
