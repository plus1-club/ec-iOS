//
//  RequestByCodeOrderController.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 21/11/19.
//  Updated by Sergey Lavrov on 02/04/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import UIKit

class RequestByCodeOrderController: UIViewController {

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
            
            Basket().getProductByCode(product: product.text!, count: quantity.text!, fullSearch: !isAdvanceSearch.isSelected, successBlock: { (basketArray) in
                
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "SearchController") as! SearchController
                controller.basketArray = basketArray
                self.navigationController?.pushViewController(controller, animated: true)
                
            }) { (error) in
                 Utilities.showAlert(strTitle: error, strMessage: nil, parent: self, OKButtonTitle: nil, CancelButtonTitle: nil, okBlock: nil, cancelBlock: nil)
            }
        }
    }
}
