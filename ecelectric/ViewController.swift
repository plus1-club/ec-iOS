//
//  ViewController.swift
//  ecelectirc
//
//  Created by Sam on 13/08/2019.
//  Copyright © 2019 Samir Azizov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var buttonRound: UIButton!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var id: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
        if let id = Constants.USER_DEFAULTS.OBJ_USER_DEFAULT.object(forKey: Constants.USER_DEFAULTS.ID) as? String,
            let password = Constants.USER_DEFAULTS.OBJ_USER_DEFAULT.object(forKey: Constants.USER_DEFAULTS.PASSWORD) as? String{
                
            performLogin(id: id, password: password)
        }
    }
    
    func isValidInput() -> Bool {
        
        if Utilities.isValidString(str: id.text) &&
            Utilities.isValidString(str: password.text) {
            
            return true
        }
        else {
            Utilities.showAlert(strTitle: Constants.MESSAGES.ENTER_VALID_LOGIN_DETAILS, strMessage: nil, parent: self, OKButtonTitle: nil, CancelButtonTitle: nil, okBlock: nil, cancelBlock: nil)
            return false
        }
    }
    
    func performLogin(id: String,
                      password: String) {
        EcElectirc.shared.user.login(id: id, password: password, successBlock: {
            
            Constants.USER_DEFAULTS.OBJ_USER_DEFAULT.set(id, forKey: Constants.USER_DEFAULTS.ID)
            Constants.USER_DEFAULTS.OBJ_USER_DEFAULT.set(password, forKey: Constants.USER_DEFAULTS.PASSWORD)
            Constants.USER_DEFAULTS.OBJ_USER_DEFAULT.synchronize()
            
            self.performSegue(withIdentifier: "pushToDashBoard", sender: self)
            
        }) { (error) in
            Utilities.showAlert(strTitle: error, strMessage: nil, parent: self, OKButtonTitle: nil, CancelButtonTitle: nil, okBlock: nil, cancelBlock: nil)

        }
    }
    
    @IBAction func loginTapped(_ sender: Button) {
        
        if isValidInput() {
            self.view.endEditing(true)
            
            performLogin(id: id.text!, password: password.text!)
        }
        
    }
    
}
