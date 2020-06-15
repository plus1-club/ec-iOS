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

    //MARK: - Outlet
    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var buttonEnter: Button!
    @IBOutlet weak var enterText: UILabel!

    //MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        // Autologin
        if  let id = Constants.DEFAULTS.SELF.object(forKey: Constants.DEFAULTS.ID) as? String,
            let password = Constants.DEFAULTS.SELF.object(forKey: Constants.DEFAULTS.PASSWORD) as? String{
                performLogin(id: id, password: password)
        }
    }
    
    //MARK: - Method
    func performLogin(id: String, password: String) {
        Auth.shared.user.login(id: id, password: password, successBlock: {
            Constants.DEFAULTS.SELF.set(id, forKey: Constants.DEFAULTS.ID)
            Constants.DEFAULTS.SELF.set(password, forKey: Constants.DEFAULTS.PASSWORD)
            Constants.DEFAULTS.SELF.synchronize()
            self.performSegue(withIdentifier: "pushToDashBoard", sender: self)
        }) { (error) in
            Utilities.showAlert(strTitle: error, strMessage: nil, parent: self,
                                OKButtonTitle: nil, CancelButtonTitle: nil,
                                okBlock: nil, cancelBlock: nil)
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

    //MARK: - Event
    @IBAction func touchEnter(_ sender: UIButton) {
        if isValidInput() {
            self.view.endEditing(true)
            performLogin(id: id.text!, password: password.text!)
        }
    }
}
