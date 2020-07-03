//
//  SearchController.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 21/11/19.
//  Refactored by Sergey Lavrov on 16/06/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import UIKit

class SearchController: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var searchTableView: UITableView!
    
    //MARK: - Variable
    var basketArray = [Basket]()
    var refreshControl = UIRefreshControl()

    //MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl.attributedTitle = NSAttributedString(string: "Потяните, чтобы обновить")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        searchTableView.addSubview(refreshControl) // not required when using UITableViewController

        searchTableView.reloadData()
    }
    
    //MARK: - Selector
    @objc func refresh(sender:AnyObject) {
        searchTableView.reloadData()
    }

    //MARK: - Action
    @IBAction func isSelectItemTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        let basket = self.basketArray[sender.tag]
        basket.isSelected = sender.isSelected
    }
    
    @IBAction func addToBucket(_ sender: UIButton) {
        let selectedBasket = basketArray.filter ({ $0.isSelected == true })
        if selectedBasket.count > 0 {
            self.view.endEditing(true)
            
            Basket().addItemToBucket(buckets: selectedBasket, successBlock: {
                let navController = self.storyboard?.instantiateViewController(withIdentifier: "bucketNavigation") as! UINavigationController
                self.revealViewController()?.setFront(navController, animated: true)
                
            }) { (error) in
                Utilities.tableMessage(table: self.searchTableView, refresh: self.refreshControl, message: error)
            }
        }
    }
}

//MARK: - DataSourse
extension SearchController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basketArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchView.cellIdentifier, for: indexPath as IndexPath) as! SearchView
        
        let basket = self.basketArray[indexPath.row]
        
        cell.isSelectedItem.isSelected = basket.isSelected ?? false
        cell.isSelectedItem.removeTarget(self, action: #selector(isSelectItemTapped(_:)), for: .touchUpInside)
        cell.isSelectedItem.addTarget(self, action: #selector(isSelectItemTapped(_:)), for: .touchUpInside)
                
        cell.qty.tag = indexPath.row
        cell.qty.text = basket.requestCount
        cell.qty.delegate = self
        
        cell.productName.text = basket.product
        var stockStatus: String
        var stockColor: UIColor
        (stockStatus, stockColor) = Utilities.stockColor(request: basket)
        cell.stockStatus.text = stockStatus
        cell.stockStatus.textColor = stockColor
        cell.isSelectedItem.imageView?.tintColor = stockColor

//        - stockCount = 0 - not exist at all - red(Нет)
//        - stockCount >= count - green(В наличии)
//        - stockCount < count - yellow (stockCount exist  less than required)

        changeStockStatusLabel(cell: cell, basket: basket)
        
        return cell
    }
    
    func changeStockStatusLabel(cell: SearchView, basket: Basket) {
        if let stock = Int(basket.stockCount), let request = Int(basket.requestCount) {
            let tintedImage = cell.isSelectedItem.imageView?.image?.withRenderingMode(.alwaysTemplate)
            cell.isSelectedItem.imageView?.image = tintedImage
            
            var stockStatus: String
            var stockColor: UIColor
            (stockStatus, stockColor) = Utilities.stockColor(request: basket)
            cell.stockStatus.text = stockStatus
            cell.stockStatus.textColor = stockColor
            cell.isSelectedItem.imageView?.tintColor = stockColor

        }
    }
}

//MARK: - Delegate
extension SearchController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        let row = textField.tag
        let basket = self.basketArray[row]

        basket.requestCount = updatedString
        
        let cell = searchTableView.cellForRow(at: IndexPath(row: row, section: 0)) as! SearchView
        changeStockStatusLabel(cell: cell, basket: basket)
        //itemsTableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)

        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let row = textField.tag
        let bucket = self.basketArray[row]

        bucket.requestCount = textField.text
        searchTableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }
}
