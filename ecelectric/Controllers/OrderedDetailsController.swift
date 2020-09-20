//
//  OrderedDetailsController.swift
//  EC-online
//
//  Created by Samir Azizov on 15/10/2019.
//  Refactored by Sergey Lavrov on 16/06/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//
 
 import UIKit
 
 class OrderedDetailsController: UIViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var accountNoAndDate: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    
    //MARK: - Variable
    var invoiceDetails = [Details]()
    var invoice : Invoice!
    var refreshControl = UIRefreshControl()

    //MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        setToInitialValue()
        detailsTableView.tableFooterView = UIView()
        getOrderedItemDetails()

        refreshControl.attributedTitle = NSAttributedString(string: "Потяните, чтобы обновить")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        detailsTableView.addSubview(refreshControl) // not required when using UITableViewController
    }

    //MARK: - Selector
    @objc func refresh(sender:AnyObject) {
       getOrderedItemDetails()
    }

    //MARK: - API
    func getOrderedItemDetails() {
        Utilities.tableMessage(table: self.detailsTableView, refresh: self.refreshControl, message: "")
        refreshControl.beginRefreshing()
        self.invoiceDetails.removeAll()
        Details().getOrderedDetails(
            accountNo: invoice.number,
            successBlock: { (invoices) in
                self.accountNoAndDate.text = String(format: "Счет № %@ от %@", arguments: [self.invoice.number, self.invoice.date])
                self.totalAmount.text = String(format: "Итого: %@ pyб.", arguments: [self.invoice.sum])
                self.invoiceDetails = invoices
                self.detailsTableView.reloadData()
                self.refreshControl.endRefreshing()
            },
            errorBlock: { (error) in
                self.detailsTableView.reloadData()
                self.refreshControl.endRefreshing()
                Utilities.tableMessage(table: self.detailsTableView, refresh: self.refreshControl, message: error)
            }
        )
    }
    
    //MARK: - Method
    func setToInitialValue() {
        self.accountNoAndDate.text = ""
        self.totalAmount.text = ""
    }
    
    //MARK: - Action
    @IBAction func backTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
 } 
 
//MARK: - DataSource
 extension OrderedDetailsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.invoiceDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderedDetailsCell", for: indexPath) as! OrderedDetailsView
        
        let details = self.invoiceDetails[indexPath.row]
        cell.productName.text = details.product
        cell.countAndAvailable.text = String(format: "%@ %@     %@", arguments: [details.count, details.unit, details.available])
        cell.countAndAvailable.textColor = Utilities.availableColor(available: details.available)
        cell.price.text = String(format: "%@ pyб.", arguments: [details.price])
        
        return cell
    }
 }
 
