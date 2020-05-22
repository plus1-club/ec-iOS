//
//  BasketController.swift
//  EC-online
//
//  Created by Samir Azizov on 11/09/2019.
//  Updated by Sergey Lavrov on 02/04/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import UIKit

class BasketController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var comment: UITextField!
    @IBOutlet weak var requestTableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var grandTotal: UILabel!
    
    var basketArray = [Basket]()
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculateGrandTotal()
        
        requestTableView.delegate = self
        requestTableView.dataSource = self
        requestTableView.estimatedRowHeight = 70
        requestTableView.tableFooterView = UIView()

        setupSideMenu()
        
        getBucket(isShowLoader: true)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Потяните, чтобы обновить")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        requestTableView.addSubview(refreshControl) // not required when using UITableViewController

    }
    
    //MARK: Refresh Data
    @objc func refresh(sender:AnyObject) {
       // Code to refresh table view
        getBucket(isShowLoader: false)
    }
    
    //MARK: APIs
    func getBucket(isShowLoader: Bool) {
        Basket().getBucket(isShowLoader: isShowLoader,
                           successBlock: { (basketArray) in
                            
                            self.basketArray = basketArray
                            self.requestTableView.reloadData()
                            self.calculateGrandTotal()
                            self.refreshControl.endRefreshing()
                            
        }) { (error) in
            Utilities.showAlert(strTitle: error, strMessage: nil, parent: self, OKButtonTitle: nil, CancelButtonTitle: nil, okBlock: nil, cancelBlock: nil)
            self.refreshControl.endRefreshing()
        }
    }
    
    
    func setupSideMenu() {
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            revealViewController().rightViewRevealWidth = 275
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    //MARK: IBActions
    @IBAction func clearTapped(_ sender: Button) {
        Basket().clearBucket(successBlock: {
            self.basketArray.removeAll()
            self.requestTableView.reloadData()
            self.calculateGrandTotal()

            Utilities.showAlert(strTitle: "Корзина очищена", strMessage: nil, parent: self, OKButtonTitle: nil, CancelButtonTitle: nil, okBlock: nil, cancelBlock: nil)

        }) { (error) in
            Utilities.showAlert(strTitle: error, strMessage: nil, parent: self, OKButtonTitle: nil, CancelButtonTitle: nil, okBlock: nil, cancelBlock: nil)
        }
    }
    
    @IBAction func addTapped(_ sender: Button) {
        let navController = self.storyboard?.instantiateViewController(withIdentifier: "RequestCheckController") as! UINavigationController
        self.revealViewController()?.setFront(navController, animated: true)
    }
    
    @IBAction func checkoutTapped(_ sender: Button) {
        Basket().createOrder(buckets: self.basketArray, comment: comment.text ?? "", successBlock: {
            Utilities.showAlert(strTitle: "Заказ размещен", strMessage: nil, parent: self, OKButtonTitle: nil, CancelButtonTitle: nil, okBlock: nil, cancelBlock: nil)

        }) { (error) in
            Utilities.showAlert(strTitle: error, strMessage: nil, parent: self, OKButtonTitle: nil, CancelButtonTitle: nil, okBlock: nil, cancelBlock: nil)
        }
        
        Basket().clearBucket(successBlock: {
            self.basketArray.removeAll()
            self.requestTableView.reloadData()
            self.calculateGrandTotal()
            self.comment.text = ""

        }) { (error) in
            Utilities.showAlert(strTitle: error, strMessage: nil, parent: self, OKButtonTitle: nil, CancelButtonTitle: nil, okBlock: nil, cancelBlock: nil)
        }
    }
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        self.view.endEditing(false)
        self.basketArray.remove(at: sender.tag)
//        requestTableView.deleteRows(at: [IndexPath(row: sender.tag, section: 0)], with: .fade)
        requestTableView.reloadData()
        calculateGrandTotal()
    }
    
    //MARK: TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basketArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let requestTableCell = tableView.dequeueReusableCell(withIdentifier: "basketCell", for: indexPath as IndexPath) as! BasketView
        
        let basket = self.basketArray[indexPath.row]
        requestTableCell.invoiceNumber1.text = String(format: "%@", arguments: [basket.product])
        
        requestTableCell.qty.tag = indexPath.row
        requestTableCell.qty.text = basket.requestCount
        requestTableCell.qty.delegate = self
        requestTableCell.invoiceAmount1.text = String(format: "%@ руб.", arguments: [Utilities.formatedAmount(amount: basket.sum as Any)])
        requestTableCell.itemPrice1.text = String(format: "%@", arguments: [basket.stockStatus])
        requestTableCell.unit.text = String(format: "%@", arguments: [basket.unit])

        requestTableCell.deleteItem.tag = indexPath.row
        requestTableCell.deleteItem.removeTarget(self, action: #selector(deleteTapped(_:)), for: .touchUpInside)
        requestTableCell.deleteItem.addTarget(self, action: #selector(deleteTapped(_:)), for: .touchUpInside)
        
        return requestTableCell
    }
    
    
    func calculateGrandTotal() {
        var total: Double = 0
        for basket in basketArray {
            total += (Double(basket.requestCount) ?? 0) * (Double(basket.price) ?? 0)
        }
        
        grandTotal.text = String(format: "Итого: %@ pyб.", arguments: [Utilities.formatedAmount(amount: total)])
    }
}

extension BasketController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let basket = self.basketArray[textField.tag]

        basket.requestCount = textField.text
        
        calculateGrandTotal()
    }
}
