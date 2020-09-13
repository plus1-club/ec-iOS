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
    var searchArray = [Basket]()
    var refreshControl = UIRefreshControl()
    var variants = [String : Int]()
    var variantNames = [String]()
    var backNavigation = UINavigationController()
    
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
    func setVariants(){
        for item in searchArray {
            if variants.keys.contains(item.requestProduct){
                let newCount = (variants[item.requestProduct] ?? 0) + 1;
                variants.updateValue(newCount, forKey: item.requestProduct)
            } else {
                variants[item.requestProduct] = 1
                variantNames.append(item.requestProduct)
            }
        }
        for item in searchArray {
            item.variantsCount = variants[item.requestProduct]
        }
    }
    
    func setupBackButton(){
        let backButton = UIBarButtonItem(title: "Назад", style: UIBarButtonItem.Style.plain, target: self, action: #selector(back(sender:)))
        self.navigationItem.leftBarButtonItem = backButton
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
        self.navigationController?.setViewControllers(backNavigation.viewControllers, animated: true)
    }

    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier != "AddToBasket"){
            return
        }
        var selectedArray: [Basket] = []
        for search in searchArray {
            if (search.isSelected == true) {
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
    
    //MARK: - Action
    @IBAction func onSelectAll(_ sender: Button) {
        for section in 0..<searchTableView.numberOfSections{
            let filteredArray = searchArray.filter(){
                return $0.requestProduct == variantNames[section]
            }
            for row in 1..<searchTableView.numberOfRows(inSection: section)-1 {
                filteredArray[row-1].isSelected = true
            }
        }
        searchTableView.reloadData()
    }
    
    @IBAction func onClearAll(_ sender: Button) {
        for section in 0..<searchTableView.numberOfSections{
            let filteredArray = searchArray.filter(){
                return $0.requestProduct == variantNames[section]
            }
            for row in 1..<searchTableView.numberOfRows(inSection: section)-1 {
                filteredArray[row-1].isSelected = false
                print(filteredArray[row-1].number!, "/", filteredArray.count)
                print(filteredArray[row-1].product!)
                //print(filteredArray[row-1].isSelected!)
            }
        }
        searchTableView.reloadData()
    }
    
    //MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return variants.count
        //return searchArray.count
        //return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //return "test"
        return variantNames[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 1
        return variants[variantNames[section]] ?? 1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let basket = self.searchArray[indexPath.row]
        if (Int.init(basket.requestCount) == 0) {
            return 0
        } else if ((Int(basket.multiplicity) ?? 0) > 1){
            return 170
        } else {
            return 120
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath as IndexPath) as! SearchView

        let sectionName = variantNames[indexPath.section]
        let filteredArray = searchArray.filter(){
            return $0.requestProduct == sectionName
        }
        let search = filteredArray[indexPath.row]
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
        
        if (Int.init(search.stockCount) == -3){
            cell.isChecked.isHidden = true;
            cell.count.isHidden = true;
            cell.unit.isHidden = true;
            cell.status.text = "Не найден";
        }
        //if (Int.init(search.variantsCount) > 1){
            // TODO: Change check box to radio button
        //}

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionName = variantNames[indexPath.section]
        let filteredArray = searchArray.filter(){
            return $0.requestProduct == sectionName
        }
        let search = filteredArray[indexPath.row]
        if (search.isSelected == true) {
            search.isSelected = false
        } else {
            search.isSelected = true
        }
        tableView.reloadData()
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
