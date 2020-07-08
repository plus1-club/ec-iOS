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
        
        refreshControl.attributedTitle = NSAttributedString(string: "Потяните, чтобы обновить")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        searchTableView.addSubview(refreshControl) // not required when using UITableViewController

        searchTableView.reloadData()
        refreshControl.endRefreshing()

    }
    
    func setupBackButton(){
        //create the uibutton
        let button = UIButton(type: .custom)
        button.setTitle("Назад", for: .normal)
        button.addTarget(self, action: #selector(back(sender:)), for: .touchDragInside)
        //button?.addTarget(
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
        let selected = self.searchArray[sender.tag]
        selected.isSelected = sender.isSelected
    }
    
    /*
    @IBAction func addToBucket(_ sender: UIButton) {
        let selected = searchArray.filter ({ $0.isSelected == true })
        if selected.count > 0 {
            self.view.endEditing(true)
            
            Basket().addItemToBucket(buckets: selected, successBlock: {
                let navController = self.storyboard?.instantiateViewController(withIdentifier: "BasketNavigation") as! UINavigationController
                self.navigationController?.pushViewController(navController, animated: true)
                
            }) { (error) in
                Utilities.tableMessage(table: self.searchTableView, refresh: self.refreshControl, message: error)
            }
        }
    }
 */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selected = searchArray.filter ({ $0.isSelected == true })
        if (segue.identifier == "AddToBasket" && selected.count > 0) {
            self.view.endEditing(true)
            Basket().addItemToBucket(buckets: selected,
            successBlock: {
                //let navController = self.storyboard?.instantiateViewController(withIdentifier: "BasketNavigation") as! UINavigationController
                //self.navigationController?.pushViewController(navController, animated: true)
                
                let navigation = segue.destination as! UINavigationController
                let controller = navigation.viewControllers.first as! BasketController
                //controller.searchArray = searchArray
                controller.basketTableView.reloadData()
                controller.refreshControl.endRefreshing()

            },
            errorBlock: { (error) in
                Utilities.tableMessage(table: self.searchTableView, refresh: self.refreshControl, message: error)
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath as IndexPath) as! SearchView

        let search = self.searchArray[indexPath.row]
        var stockStatus: String
        var stockColor: UIColor
        (stockStatus, stockColor) = Utilities.stockColor(request: search)
        
        cell.isChecked.isSelected = search.isSelected ?? false
        cell.isChecked.removeTarget(self, action: #selector(isCheckedTapped(_:)), for: .touchUpInside)
        cell.isChecked.addTarget(self, action: #selector(isCheckedTapped(_:)), for: .touchUpInside)
 
        cell.count.tag = indexPath.row
        cell.count.text = search.requestCount
        cell.count.delegate = self
        cell.count.textColor = stockColor
        cell.count.layer.borderColor = stockColor.cgColor

        cell.product.text = String(format: "%@", arguments: [search.product])

        cell.status.text = String(format: "%@   %@", arguments: [search.unit, search.product])
        if ((Int(search.multiplicity) ?? 0) > 1){
            cell.status.text = String(format: "%@   %@\nУвеличено до кратности минимальной упаковки: %@ (по %@ в упаковке)", arguments: [search.unit, stockStatus, search.requestCount, search.multiplicity])
        } else {
            cell.status.text = String(format: "%@   %@", arguments: [search.unit, stockStatus])
        }
        cell.status.textColor = stockColor

        return cell
    }
    
    func changeStatus(cell: SearchView, selected: Basket){
        var stockStatus: String
        var stockColor: UIColor
        (stockStatus, stockColor) = Utilities.stockColor(request: selected)
        cell.status.text = stockStatus
        cell.status.textColor = stockColor
        cell.isChecked.imageView?.tintColor = stockColor

        //        - stockCount = 0 - not exist at all - red(Нет)
        //        - stockCount >= count - green(В наличии)
        //        - stockCount < count - yellow (stockCount exist  less than required)
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
        //itemsTableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)

        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let selected = self.searchArray[textField.tag]
        selected.requestCount = textField.text
        searchTableView.reloadRows(at: [IndexPath(row: textField.tag, section: 0)], with: .automatic)
    }
}
