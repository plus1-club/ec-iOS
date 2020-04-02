//
//  EnterController.swift
//  EC-online
//
//  Created by Samir Azizov on 13/08/2019.
//  Updated by Sergey Lavrov on 02/04/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import UIKit

class EnterController: UIViewController {

    @IBOutlet weak var id: UITextField!
    
    
    @IBOutlet weak var password: UITextField!
    
    
    @IBOutlet weak var buttonEnter: Button!
    
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
        Auth.shared.user.login(id: id, password: password, successBlock: {
            
            Constants.USER_DEFAULTS.OBJ_USER_DEFAULT.set(id, forKey: Constants.USER_DEFAULTS.ID)
            Constants.USER_DEFAULTS.OBJ_USER_DEFAULT.set(password, forKey: Constants.USER_DEFAULTS.PASSWORD)
            Constants.USER_DEFAULTS.OBJ_USER_DEFAULT.synchronize()
            
            self.performSegue(withIdentifier: "pushToDashBoard", sender: self)
            
        }) { (error) in
            Utilities.showAlert(strTitle: error, strMessage: nil, parent: self, OKButtonTitle: nil, CancelButtonTitle: nil, okBlock: nil, cancelBlock: nil)

        }
    }
    
    @IBAction func touchEnter(_ sender: Any) {
        if isValidInput() {
            self.view.endEditing(true)
            
            performLogin(id: id.text!, password: password.text!)
        }
    }
    
    
}
