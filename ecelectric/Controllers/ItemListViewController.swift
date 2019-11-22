//
//  ItemListViewController.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 21/11/19.
//  Copyright © 2019 Samir Azizov. All rights reserved.
//

import UIKit

class ItemInfoTableViewCell : UITableViewCell {
    static let cellIdentifier = "itemsTableCell"
    
    @IBOutlet weak var isSelectedItem: UIButton!
    @IBOutlet weak var qty: UITextField!
    @IBOutlet weak var stockStatus: UILabel!
    @IBOutlet weak var productName: UILabel!
    
}

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
       
        
        
        return cell
    }
}

extension ItemListViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let bucket = self.buckets[textField.tag]

        bucket.requestCount = textField.text
        

    }
}
