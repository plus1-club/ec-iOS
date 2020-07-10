//
//  SearchController.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 21/11/19.
//  Refactored by Sergey Lavrov on 16/06/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import UIKit

class SearchController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: - Outlet
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var searchTableView: UITableView!

    //MARK: - Variable
    var searchArray: [Basket] = []
    var refreshControl = UIRefreshControl()
    
    //MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.delegate = self
        searchTableView.dataSource = self

        setupBackButton()
        setupSideMenu()
        refreshData()
    }
    
    //MARK: - Method
    func setupBackButton(){
        let button = UIButton(type: .custom)
        button.setTitle("Назад", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(back(sender:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }

    func setupSideMenu() {
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            revealViewController().rightViewRevealWidth = 275
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func refreshData() {
        for item in searchArray {
            item.isSelected = false
        }
        refreshControl.attributedTitle = NSAttributedString(string: "Потяните, чтобы обновить")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        searchTableView.addSubview(refreshControl) // not required when using UITableViewController
        searchTableView.reloadData()
        refreshControl.endRefreshing()
    }

    func changeStatus(cell: SearchView, selected: Basket){
        var stockStatus: String
        var stockColor: UIColor
        (stockStatus, stockColor) = Utilities.stockColor(request: selected)
        cell.status.text = stockStatus
        cell.status.textColor = stockColor
        cell.isChecked.imageView?.tintColor = stockColor
    }

    //MARK: - Selector
    @objc func refresh(sender:AnyObject) {
        let search = self.searchArray[0]
        search.isSelected = true
        searchTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    @objc func back(sender:AnyObject){
        _ = navigationController?.popViewController(animated: true)
    }

    //MARK: - Action
    @IBAction func isCheckedTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let selected = searchArray[sender.tag]
        selected.isSelected = sender.isSelected
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier != "AddToBasket"){
            return
        }
        var selectedArray: [Basket] = []
        for search in searchArray {
            if ((search.isSelected) != nil && search.isSelected == true) {
                selectedArray.append(search)
            }
        }
        if (selectedArray.count > 0) {
            self.view.endEditing(true)
            self.refreshControl.beginRefreshing()
            Basket().addToBasket(
                basketArray: selectedArray,
                successBlock: { (basketArray) in
                    let navigation = segue.destination as! UINavigationController
                    let controller = navigation.viewControllers.first as! BasketController
                    controller.basketArray = basketArray
                    controller.basketTableView.reloadData()
                    controller.refreshControl.endRefreshing()
                },
                errorBlock: { (error) in
                    Utilities.tableMessage(table: self.searchTableView, refresh: self.refreshControl, message: error)
            })
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier != "AddToBasket"){
            return false
        }
        var selectedArray: [Basket] = []
        for search in searchArray {
            if ((search.isSelected) != nil && search.isSelected == true) {
                selectedArray.append(search)
            }
        }
        if (selectedArray.count > 0) {
            return true
        } else {
            Utilities.alertMessage(parent: self, message: "Не выбран товар для добавления в корзину")
            return false
        }
    }
    
    //MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let basket = self.searchArray[indexPath.row]
        if ((Int(basket.multiplicity) ?? 0) > 1){
            return 170
        } else {
            return 120
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath as IndexPath) as! SearchView

        let search = self.searchArray[indexPath.row]
        var stockStatus: String
        var stockColor: UIColor
        (stockStatus, stockColor) = Utilities.stockColor(request: search)
        
        let multiplicity = Int(search.multiplicity)!
        if (multiplicity > 1){
            var count = Int(search.requestCount)!
            if (count % multiplicity) > 0 {
                count += multiplicity - (count % multiplicity)
            }
            search.requestCount = String(count)
            cell.multiplicity.isHidden = false
            cell.multiplicity.text = String(format: "Увеличено до кратности минимальной упаковки: %@ (по %@ в упаковке)", arguments: [search.requestCount, search.multiplicity])
            cell.multiplicity.textColor = stockColor
        } else {
            cell.multiplicity.isHidden = true
        }

        cell.isChecked.isSelected = search.isSelected ?? false
        cell.isChecked.removeTarget(self, action: #selector(isCheckedTapped(_:)), for: .touchUpInside)
        cell.isChecked.addTarget(self, action: #selector(isCheckedTapped(_:)), for: .touchUpInside)

        cell.count.delegate = self
        cell.count.tag = indexPath.row
        cell.count.text = search.requestCount
        cell.count.textColor = stockColor
        cell.count.layer.borderColor = stockColor.cgColor

        cell.unit.text = String(format: "%@", arguments: [search.unit])
        cell.unit.textColor = stockColor

        cell.product.text = String(format: "%@", arguments: [search.product])

        cell.status.text = String(format: "%@", arguments: [stockStatus])
        cell.status.textColor = stockColor

        return cell
    }
}

//MARK: - Delegate
extension SearchController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        let row = textField.tag
        let selected = self.searchArray[row]

        selected.requestCount = updatedString        
        let cell = searchTableView.cellForRow(at: IndexPath(row: row, section: 0)) as! SearchView
        changeStatus(cell: cell, selected: selected)

        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let selected = self.searchArray[textField.tag]
        selected.requestCount = textField.text
        searchTableView.reloadRows(at: [IndexPath(row: textField.tag, section: 0)], with: .automatic)
    }
}
