//
//  CheckTheAvailibilityViewController.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 21/11/19.
//  Copyright © 2019 Samir Azizov. All rights reserved.
//

import UIKit

class CheckTheAvailibilityViewController: UIViewController {

    @IBOutlet weak var product: UITextField!
    @IBOutlet weak var quantity: UITextField!
    @IBOutlet weak var isAdvanceSearch: Button!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func isValidInput() -> Bool {
        
        if Utilities.isValidString(str: product.text) &&
            Utilities.isValidString(str: quantity.text) {
            
            return true
        }
        else {
            Utilities.showAlert(strTitle: Constants.MESSAGES.ENTER_VALID_DETAILS, strMessage: nil, parent: self, OKButtonTitle: nil, CancelButtonTitle: nil, okBlock: nil, cancelBlock: nil)
            return false
        }
    }
    
    @IBAction func isAdvanceSearchTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func checkTapped(_ sender: Button) {
        
        if isValidInput() {
            
            Bucket().getProductByCode(product: product.text!, count: quantity.text!, fullSearch: !isAdvanceSearch.isSelected, successBlock: { (buckets) in
                
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "ItemListViewController") as! ItemListViewController
                controller.buckets = buckets
                self.navigationController?.pushViewController(controller, animated: true)
                
            }) { (error) in
                 Utilities.showAlert(strTitle: error, strMessage: nil, parent: self, OKButtonTitle: nil, CancelButtonTitle: nil, okBlock: nil, cancelBlock: nil)
            }
        }
    }
    
    
    

}
