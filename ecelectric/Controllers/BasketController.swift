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
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var basketTableView: UITableView!
    @IBOutlet weak var grandTotal: UILabel!
    @IBOutlet weak var comment: UITextField!
    
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
        
        self.refreshControl.beginRefreshing()
        getBucket()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Потяните, чтобы обновить")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        basketTableView.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    //MARK: - Selector
    @objc func refresh(sender:AnyObject) {
       // Code to refresh table view
        getBucket()
    }
    
    //MARK: - API
    func getBucket() {
        LoadingOverlay.shared.showOverlay(view: self.view)
        Basket().getBasket(
            successBlock: { (basketArray) in
                self.basketArray = basketArray
                self.basketTableView.reloadData()
                self.calculateGrandTotal()
                self.refreshControl.endRefreshing()
                LoadingOverlay.shared.hideOverlayView()
            },
            errorBlock: { (error) in
                LoadingOverlay.shared.hideOverlayView()
                Utilities.tableMessage(table: self.basketTableView, refresh: self.refreshControl, message: error)
            }
        )
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
        refreshControl.beginRefreshing()
        Utilities.tableMessage(table: self.basketTableView, refresh: self.refreshControl, message: "")
        Basket().clearBasket(
            successBlock: {
                self.basketArray.removeAll()
                self.basketTableView.reloadData()
                self.calculateGrandTotal()
                self.refreshControl.endRefreshing()
                Utilities.tableMessage(table: self.basketTableView, refresh: self.refreshControl, message: "Корзина очищена")
            },
            errorBlock: { (error) in
                self.refreshControl.endRefreshing()
                Utilities.tableMessage(table: self.basketTableView, refresh: self.refreshControl, message: error)
            }
        )
    }
    
    @IBAction func addTapped(_ sender: Button) {
        let navController = self.storyboard?.instantiateViewController(withIdentifier: "RequestOrderNavigation") as! UINavigationController
        self.revealViewController()?.setFront(navController, animated: true)
    }
    
    @IBAction func checkoutTapped(_ sender: Button) {
        LoadingOverlay.shared.showOverlay(view: self.view)
        Utilities.tableMessage(table: self.basketTableView, refresh: self.refreshControl, message: "")
        Basket().createOrder(
            basketArray: self.basketArray,
            comment: comment?.text ?? "",
            successBlock: { (order) in
                Utilities.tableMessage(table: self.basketTableView, refresh: self.refreshControl, message: String(format: "Заказ %@ размещен", arguments: [order]))
                Basket().clearBasket(
                    successBlock: {
                        self.basketArray.removeAll()
                        self.basketTableView.reloadData()
                        self.calculateGrandTotal()
                        self.comment.text = ""
                        LoadingOverlay.shared.hideOverlayView()
                    },
                    errorBlock: { (error) in
                        self.basketArray.removeAll()
                        self.basketTableView.reloadData()
                        LoadingOverlay.shared.hideOverlayView()
                        Utilities.tableMessage(table: self.basketTableView, refresh: self.refreshControl, message: error)
                    }
                )
            },
            errorBlock: { (error) in
                LoadingOverlay.shared.hideOverlayView()
                Utilities.tableMessage(table: self.basketTableView, refresh: self.refreshControl, message: error)
            }
        )
    }
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        refreshControl.beginRefreshing()
        LoadingOverlay.shared.showOverlay(view: basketTableView)
        Utilities.tableMessage(table: self.basketTableView, refresh: self.refreshControl, message: "")
        if basketArray.count > 0 {
            basketArray.remove(at: sender.tag)
            basketTableView.deleteRows(at: [ IndexPath(row: sender.tag, section: 0) ], with: .fade)
            self.calculateGrandTotal()
            Basket().updateBasket(
                basketArray: basketArray,
                successBlock: {
                    Basket().getBasket(
                        successBlock: { (basketArray) in
                            self.basketTableView.reloadData()
                            self.refreshControl.endRefreshing()
                            LoadingOverlay.shared.hideOverlayView()
                        },
                        errorBlock: { (error) in
                            LoadingOverlay.shared.hideOverlayView()
                            Utilities.tableMessage(table: self.basketTableView, refresh: self.refreshControl, message: error)
                        }
                    )
                },
                errorBlock: { (error) in
                    LoadingOverlay.shared.hideOverlayView()
                    self.refreshControl.endRefreshing()
                    Utilities.tableMessage(table: self.basketTableView, refresh: self.refreshControl, message: error)
            })
        } else {
            Basket().clearBasket(
                successBlock: {
                    self.basketArray.removeAll()
                    self.basketTableView.reloadData()
                    self.calculateGrandTotal()
                    self.comment.text = ""
                    self.refreshControl.endRefreshing()
                    LoadingOverlay.shared.hideOverlayView()
                },
                errorBlock: { (error) in
                    LoadingOverlay.shared.hideOverlayView()
                    self.refreshControl.endRefreshing()
                    Utilities.tableMessage(table: self.basketTableView, refresh: self.refreshControl, message: error)
                }
            )
        }
    }
    
    //MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basketArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basketCell", for: indexPath as IndexPath) as! BasketView
        
        let basket = self.basketArray[indexPath.row]
        var stockStatus: String
        var stockColor: UIColor
        (stockStatus, stockColor) = Utilities.stockColor(request: basket)
                
        let multiplicity = Int(basket.multiplicity == "" ? "0" : basket.multiplicity)!
        if (multiplicity > 1){
           var count = Int(basket.requestCount)!
           if (count % multiplicity) > 0 {
               count += multiplicity - (count % multiplicity)
           }
           basket.requestCount = String(count)
           cell.multiplicity.isHidden = false
           cell.multiplicity.text = String(format: "Увеличено до кратности минимальной упаковки: %@ (по %@ в упаковке)", arguments: [basket.requestCount, basket.multiplicity])
           cell.multiplicity.textColor = stockColor
       } else {
           cell.multiplicity.isHidden = true
       }
        
        cell.count.tag = indexPath.row
        cell.count.text = basket.requestCount
        cell.count.delegate = self
        cell.count.textColor = stockColor
        cell.count.layer.borderColor = stockColor.cgColor

        cell.unit.text = String(format: "%@", arguments: [basket.unit])
        cell.unit.textColor = stockColor

        cell.product.text = String(format: "%@", arguments: [basket.product])

        cell.sum.text = String(format: "%@ руб.", arguments: [Utilities.formatedAmount(amount: basket.sum as Any)])
        
        cell.status.text = stockStatus
        cell.status.textColor = stockColor

        cell.deleteItem.tag = indexPath.row
        cell.deleteItem.removeTarget(self, action: #selector(deleteTapped(_:)), for: .touchUpInside)
        cell.deleteItem.addTarget(self, action: #selector(deleteTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let basket = self.basketArray[indexPath.row]
        if ((Int(basket.multiplicity) ?? 0) > 1){
            return 170
        } else {
            return 120
        }
    }
}

//MARK: - Delegate
extension BasketController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        Utilities.tableMessage(table: self.basketTableView, refresh: self.refreshControl, message: "")
        refreshControl.beginRefreshing()
        let basket = self.basketArray[textField.tag]
        basket.requestCount = textField.text
        basket.sum = String((Double(basket.requestCount) ?? 0) * (Double(basket.price) ?? 0))
        Basket().updateBasket(
            basketArray: basketArray,
            successBlock: {
                Basket().getBasket(
                    successBlock: { (basketArray) in
                        self.basketArray = basketArray
                        self.basketTableView.reloadRows(at: [IndexPath(row: textField.tag, section: 0)], with: .automatic)
                        self.basketTableView.reloadData()
                        self.calculateGrandTotal()
                        self.refreshControl.endRefreshing()
                        LoadingOverlay.shared.hideOverlayView()
                    },
                    errorBlock: { (error) in
                        LoadingOverlay.shared.hideOverlayView()
                        Utilities.tableMessage(table: self.basketTableView, refresh: self.refreshControl, message: error)
                    }
                )
            },
            errorBlock: { (error) in
                self.refreshControl.endRefreshing()
                Utilities.tableMessage(table: self.basketTableView, refresh: self.refreshControl, message: error)
            }
        )
    }
}
