//
//  ItemListViewController.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 21/11/19.
//  Copyright © 2019 Samir Azizov. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {

    var buckets = [Bucket]()
    @IBOutlet weak var itemsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        itemsTableView.reloadData()
        
    }
    
    @IBAction func isSelectItemTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        let bucket = self.buckets[sender.tag]
        bucket.isSelected = sender.isSelected
        
    }
    
    @IBAction func addToBucket(_ sender: UIButton) {
        
        let selectedBucket = buckets.filter ({ $0.isSelected == true })
        if selectedBucket.count > 0 {
            self.view.endEditing(true)

            Bucket().addItemToBucket(buckets: selectedBucket, successBlock: {
                
                let navController = self.storyboard?.instantiateViewController(withIdentifier: "bucketNavigation") as! UINavigationController
                self.revealViewController()?.setFront(navController, animated: true)
                
                
            }) { (error) in
                Utilities.showAlert(strTitle: error, strMessage: nil, parent: self, OKButtonTitle: nil, CancelButtonTitle: nil, okBlock: nil, cancelBlock: nil)

            }
        }
        
        
    }
    

}

extension ItemListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buckets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemInfoTableViewCell.cellIdentifier, for: indexPath as IndexPath) as! ItemInfoTableViewCell
        
        let bucket = self.buckets[indexPath.row]
        
        cell.isSelectedItem.isSelected = bucket.isSelected ?? false
        cell.isSelectedItem.removeTarget(self, action: #selector(isSelectItemTapped(_:)), for: .touchUpInside)
        cell.isSelectedItem.addTarget(self, action: #selector(isSelectItemTapped(_:)), for: .touchUpInside)
                
        cell.qty.tag = indexPath.row
        cell.qty.text = bucket.requestCount
        cell.qty.delegate = self
        
        cell.productName.text = bucket.product
      
//        - stockCount = 0 - not exist at all - red(Нет)
//        - stockCount >= count - green(В наличии)
//        - stockCount < count - yellow (stockCount exist  less than required)

        changeStockStatusLabel(cell: cell, bucket: bucket)
        
        
        return cell
    }
    
    func changeStockStatusLabel(cell: ItemInfoTableViewCell, bucket: Bucket) {
        if let stock = Int(bucket.stockCount), let request = Int(bucket.requestCount) {
            
            let tintedImage = cell.isSelectedItem.imageView?.image?.withRenderingMode(.alwaysTemplate)
            cell.isSelectedItem.imageView?.image = tintedImage
            

            if stock == 0 {
                cell.stockStatus.text = "Нет"
                cell.stockStatus.textColor = UIColor.red
                cell.isSelectedItem.imageView?.tintColor = UIColor.red
            }
            else if stock >= request {
                cell.stockStatus.text = "В наличии"
                cell.stockStatus.textColor = #colorLiteral(red: 0.3079569936, green: 0.6612923145, blue: 0.3500179052, alpha: 1)
                cell.isSelectedItem.imageView?.tintColor = #colorLiteral(red: 0.3079569936, green: 0.6612923145, blue: 0.3500179052, alpha: 1)
            }
            else if stock < request {
                cell.stockStatus.text = String(format: "Есть %@ из %@", arguments: [bucket.stockCount, bucket.requestCount])
                cell.stockStatus.textColor = #colorLiteral(red: 0.9759441018, green: 0.7644813061, blue: 0.01044687536, alpha: 1)
                cell.isSelectedItem.imageView?.tintColor = #colorLiteral(red: 0.9759441018, green: 0.7644813061, blue: 0.01044687536, alpha: 1)
            }
            
            
        }
    }
}

extension ItemListViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        let row = textField.tag
        let bucket = self.buckets[row]

        bucket.requestCount = updatedString
        
        let cell = itemsTableView.cellForRow(at: IndexPath(row: row, section: 0)) as! ItemInfoTableViewCell
        changeStockStatusLabel(cell: cell, bucket: bucket)
        //itemsTableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)

        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let row = textField.tag
        let bucket = self.buckets[row]

        bucket.requestCount = textField.text
        itemsTableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)

    }
}
