//
//  Utilities.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 13/11/19.
//  Copyright © 2019 Samir Azizov. All rights reserved.
//

import UIKit

class Utilities: NSObject {
    
    //MARK: Validation methods
    class func isValidString(str:String?) -> Bool {
        
        if str != nil && str?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            return false
        }
        return true
    }
    
    class func isValidEmail(strEmail : String?) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9_%+-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: strEmail)
    }
    
    class func isValidPassword(str:String?) -> Bool {
        if let strPWD = str {
            if(strPWD.count >= 8) {
                return true
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
    
    //MARK: Show Alert
    class func showAlert(strTitle:String, strMessage:String?, parent:AnyObject, OKButtonTitle : String? ,CancelButtonTitle : String?, okBlock : (() -> Void)?, cancelBlock : (() -> Void)?)
    {
        let alert = UIAlertController(title: strTitle, message: (strMessage ?? ""), preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: (OKButtonTitle ?? "Ok"), style: .default) { (action:UIAlertAction!) in
            if let sucessBlock = okBlock {
                sucessBlock()
            }
        }
        alert.addAction(OKAction)
        
        if CancelButtonTitle != nil {
            let CancelAction = UIAlertAction(title: CancelButtonTitle, style: .default) { (action:UIAlertAction!) in
                if let canBlock = cancelBlock {
                    canBlock()
                }
            }
            alert.addAction(CancelAction)
        }
        
        parent.present(alert, animated: true, completion: nil)
        
    }
    
    
    class func formatedAmount(amount: Any) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        if let amt = amount as? Double {
            return numberFormatter.string(from: NSNumber(value:amt))!
        }
        else if let strAmt = amount as? String, let dblAmt = Double(strAmt)  {
            
            return numberFormatter.string(from: NSNumber(value:dblAmt))!
        }

        return (amount as? String) ?? ""
    }
}
