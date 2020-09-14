//
//  EnterController.swift
//  EC-online
//
//  Created by Samir Azizov on 13/08/2019.
//  Refactored by Sergey Lavrov on 16/06/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import UIKit

class EnterController: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var buttonEnter: Button!
    @IBOutlet weak var enterText: LinkLabel!

    //MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        // Autologin
        if  let id = Constants.DEFAULTS.SELF.object(forKey: Constants.DEFAULTS.ID) as? String,
            let password = Constants.DEFAULTS.SELF.object(forKey: Constants.DEFAULTS.PASSWORD) as? String{
                performLogin(id: id, password: password)
        }
        // Link
        prepareLink()
    }
    
    //MARK: - API
    func performLogin(id: String, password: String) {
        LoadingOverlay.shared.showOverlay(view: self.view)
        Auth.shared.user.login(
            id: id,
            password: password,
            successBlock: {
                Constants.DEFAULTS.SELF.set(id, forKey: Constants.DEFAULTS.ID)
                Constants.DEFAULTS.SELF.set(password, forKey: Constants.DEFAULTS.PASSWORD)
                Constants.DEFAULTS.SELF.synchronize()
                LoadingOverlay.shared.hideOverlayView()
                self.performSegue(withIdentifier: "pushToDashBoard", sender: self)
            },
            errorBlock: {(error) in
                LoadingOverlay.shared.hideOverlayView()
                Utilities.showAlert(strTitle: error, strMessage: nil, parent: self,
                                    OKButtonTitle: nil, CancelButtonTitle: nil,
                                    okBlock: nil, cancelBlock: nil)
            }
        )
    }
    
    //MARK: - Method
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
    
    func prepareLink(){
        let linkAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.blue,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.RawValue(),
            NSAttributedString.Key.link: "tel:+74957300230"
        ]
        let link = NSMutableAttributedString(string: "+7 (495) 730-02-30")
        link.setAttributes(linkAttributes, range: NSRange(location: 0,length: link.length))
        
        let text = NSMutableAttributedString()
        text.append(enterText.attributedText ?? NSAttributedString(string: ""))
        text.append(link)
        enterText.attributedText = text
        
        enterText.onCharacterTapped = {
            enterText,
            characterIndex in
            if let _ = enterText.attributedText?.attribute(NSAttributedString.Key.link, at: characterIndex, effectiveRange: nil) as? String,
                let url = NSURL(string: "tel:74957300230"){
                UIApplication.shared.open(url as URL)
            }
        }
    }

    //MARK: - Action
    @IBAction func touchEnter(_ sender: UIButton) {
        if isValidInput() {
            self.view.endEditing(true)
            performLogin(id: id.text!, password: password.text!)
        }
    }
}
