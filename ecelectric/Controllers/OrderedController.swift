//
//  OrderedController.swift
//  EC-online
//
//  Created by Samir Azizov on 13/08/2019.
//  Updated by Sergey Lavrov on 02/04/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import UIKit

class OrderedController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var orderTableView: UITableView!
    
    
    var invoices = [Invoice]()
    var refreshControl = UIRefreshControl()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderTableView.delegate = self
        orderTableView.dataSource = self
        orderTableView.tableFooterView = UIView()

        Utilities.sideMenu(window: self, menuButton: menuButton)

        refreshControl.attributedTitle = NSAttributedString(string: "Потяните, чтобы обновить")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        orderTableView.addSubview(refreshControl) // not required when using UITableViewController

        getOrderedItemList(isShowLoader: true)
    }
        
    @objc func refresh(sender:AnyObject) {
       // Code to refresh table view
        getOrderedItemList(isShowLoader: false)
    }
    
    //MARK: - IBActions
    @IBAction func showInvoiceDetailsTapped(_ sender: UIButton) {
        let selectedInvoice = self.invoices[sender.tag]

        let controller = self.storyboard?.instantiateViewController(withIdentifier: "OrderedDetailsController") as! OrderedDetailsController
        controller.invoice = selectedInvoice
        self.navigationController?.pushViewController(controller, animated: true)

    }
    
    @IBAction func printInvoiceTapped(_ sender: UIButton) {
        let selectedInvoice = self.invoices[sender.tag]

        Invoice().getInvoicePrint(accountNo: selectedInvoice.number, successBlock: { (fileURL) in
            
            let controller = PrintController()
            controller.pdfFilePath = fileURL
            self.navigationController?.pushViewController(controller, animated: true)

            
        }) { (error) in
            Utilities.showAlert(strTitle: error, strMessage: nil, parent: self, OKButtonTitle: nil, CancelButtonTitle: nil, okBlock: nil, cancelBlock: nil)
        }

    }
    
    //MARK: - API Call
    func getOrderedItemList(isShowLoader: Bool) {
        Invoice().getOrderedItemList(isShowLoader: isShowLoader, successBlock: { (invoices) in
            
            self.invoices = invoices
            self.orderTableView.reloadData()
            self.refreshControl.endRefreshing()
            
        }) { (error) in
            //Utilities.showAlert(strTitle: error, strMessage: nil, parent: self, OKButtonTitle: nil, CancelButtonTitle: nil, okBlock: nil, cancelBlock: nil)
            let messageLabel = UILabel(frame: CGRect(x:0, y:0, width: self.orderTableView.bounds.size.width, height: self.orderTableView.bounds.size.height))
            messageLabel.text = error
            messageLabel.textColor = .black
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.sizeToFit()
            self.orderTableView.backgroundView = messageLabel;
            self.refreshControl.endRefreshing()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.invoices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderCell = tableView.dequeueReusableCell(withIdentifier: "orderedCell", for: indexPath as IndexPath) as! OrderedView
    
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