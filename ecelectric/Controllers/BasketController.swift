//
//  BasketController.swift
//  EC-online
//
//  Created by Samir Azizov on 11/09/2019.
//  Refactored by Sergey Lavrov on 16/06/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import UIKit

class BasketController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Outlet
    @IBOutlet weak var comment: UITextField!
    @IBOutlet weak var basketTableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var grandTotal: UILabel!
    
    //MARK: - Variable
    var basketArray = [Basket]()
    var refreshControl = UIRefreshControl()

    //MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculateGrandTotal()
        
        basketTableView.delegate = self
        basketTableView.dataSource = self
        basketTableView.estimatedRowHeight = 150
        basketTableView.tableFooterView = UIView()

        setupSideMenu()
        
        getBucket(isShowLoader: true)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Потяните, чтобы обновить")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        basketTableView.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    //MARK: - Selector
    @objc func refresh(sender:AnyObject) {
       // Code to refresh table view
        getBucket(isShowLoader: false)
    }
    
    //MARK: - API
    func getBucket(isShowLoader: Bool) {
        Basket().getBucket(isShowLoader: isShowLoader,
           successBlock: { (basketArray) in
            
            self.basketArray = basketArray
            self.basketTableView.reloadData()
            self.calculateGrandTotal()
            self.refreshControl.endRefreshing()
                            
        }) { (error) in
            Utilities.tableMessage(table: self.basketTableView, refresh: self.refreshControl, message: error)
        }
    }
    
    //MARK: - Method
    func setupSideMenu() {
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            revealViewController().rightViewRevealWidth = 275
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func calculateGrandTotal() {
        var total: Double = 0
        for basket in basketArray {
            total += (Double(basket.requestCount) ?? 0) * (Double(basket.price) ?? 0)
        }
        grandTotal.text = String(format: "Итого: %@ pyб.", arguments: [Utilities.formatedAmount(amount: total)])
    }

    //MARK: - Action
    @IBAction func clearTapped(_ sender: Button) {
        Basket().clearBucket(successBlock: {
            self.basketArray.removeAll()
            self.basketTableView.reloadData()
            self.calculateGrandTotal()
            
            Utilities.tableMessage(table: self.basketTableView, refresh: self.refreshControl, message: "Корзина очищена")
        }) { (error) in
            Utilities.tableMessage(table: self.basketTableView, refresh: self.refreshControl, message: error)
        }
    }
    
    @IBAction func addTapped(_ sender: Button) {
        let navController = self.storyboard?.instantiateViewController(withIdentifier: "RequestCheckNavigation") as! UINavigationController
        self.revealViewController()?.setFront(navController, animated: true)
    }
    
    @IBAction func checkoutTapped(_ sender: Button) {
        Basket().createOrder(buckets: self.basketArray, comment: comment.text ?? "", successBlock: {
            Utilities.tableMessage(table: self.basketTableView, refresh: self.refreshControl, message: "Заказ размещен")
        }) { (error) in
            Utilities.tableMessage(table: self.basketTableView, refresh: self.refreshControl, message: error)
        }
        
        Basket().clearBucket(
            successBlock: {
            self.basketArray.removeAll()
            self.basketTableView.reloadData()
            self.calculateGrandTotal()
            self.comment.text = ""
        }) { (error) in
            Utilities.tableMessage(table: self.basketTableView, refresh: self.refreshControl, message: error)
        }
    }
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        self.view.endEditing(false)
        self.basketArray.remove(at: sender.tag)
//        requestTableView.deleteRows(at: [IndexPath(row: sender.tag, section: 0)], with: .fade)
        basketTableView.reloadData()
        calculateGrandTotal()
    }
    
    //MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basketArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let basketTableCell = tableView.dequeueReusableCell(withIdentifier: "basketCell", for: indexPath as IndexPath) as! BasketView
        
        let basket = self.basketArray[indexPath.row]
        var stockStatus: String
        var stockColor: UIColor
        (stockStatus, stockColor) = Utilities.stockColor(request: basket)
                
        basketTableCell.count.tag = indexPath.row
        basketTableCell.count.text = basket.requestCount
        basketTableCell.count.delegate = self
        basketTableCell.count.textColor = stockColor
        basketTableCell.count.layer.borderColor = stockColor.cgColor

        basketTableCell.unit.text = String(format: "%@", arguments: [basket.unit])
        basketTableCell.unit.textColor = stockColor

        basketTableCell.product.text = String(format: "%@", arguments: [basket.product])

        basketTableCell.sum.text = String(format: "%@ руб.", arguments: [Utilities.formatedAmount(amount: basket.sum as Any)])
        
        basketTableCell.status.text = stockStatus
        basketTableCell.status.textColor = stockColor
     
        if ((Int(basket.multiplicity) ?? 0) > 1){
            basketTableCell.multiplicity.isHidden = false
            basketTableCell.multiplicity.text = String(format: "Увеличено до кратности минимальной упаковки: %@ (по %@ в упаковке)", arguments: [basket.requestCount, basket.multiplicity])
            basketTableCell.multiplicity.textColor = stockColor
        } else {
            basketTableCell.multiplicity.isHidden = true
            //basketTableCell.multiplicity.text = ""
            //basketTableCell.multiplicity.textColor = stockColor
        }

        basketTableCell.deleteItem.tag = indexPath.row
        basketTableCell.deleteItem.removeTarget(self, action: #selector(deleteTapped(_:)), for: .touchUpInside)
        basketTableCell.deleteItem.addTarget(self, action: #selector(deleteTapped(_:)), for: .touchUpInside)
        
        return basketTableCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let basket = self.basketArray[indexPath.row]
        if ((Int(basket.multiplicity) ?? 0) > 1){
            return 150
        } else {
            return 100
        }
    }
}

//MARK: - Delegate
extension BasketController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let basket = self.basketArray[textField.tag]
        basket.requestCount = textField.text
        calculateGrandTotal()
    }
}
