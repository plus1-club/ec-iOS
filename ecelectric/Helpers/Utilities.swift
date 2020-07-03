//
//  Utilities.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 13/11/19.
//  Updated by Sergey Lavrov on 02/04/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import UIKit

class Utilities: NSObject {
    
    //MARK: - Validation
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
    
    //MARK: - Window
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
    
    class func tableMessage(table: UITableView, refresh: UIRefreshControl, message:String){
        let messageLabel = UILabel(frame: CGRect(x:0, y:0, width: table.bounds.size.width, height: table.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        table.backgroundView = messageLabel;
        refresh.endRefreshing()
    }
    
    class func alertMessage(parent: AnyObject, message: String){
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "ok", style: .default)
        alertController.addAction(OKAction)
        parent.present(alertController, animated: true, completion: nil)
    }

    class func sideMenu(window: UIViewController, menuButton: UIBarButtonItem){
        if window.revealViewController() != nil {
            menuButton.target = window.revealViewController()
            menuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            window.revealViewController().rightViewRevealWidth = 275
            window.view.addGestureRecognizer(window.revealViewController().panGestureRecognizer())
        }
    }
    
    //MARK: - Format
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
    
    //MARK: - Colors
    class func availableColor(available: String) -> UIColor {
        if (available == "Нет"){
            return UIColor.red
        } else if (available == "В наличии"){
            return UIColor(red: 0, green: 0.7, blue: 0, alpha: 1)
        } else if (available.hasPrefix("Есть только")){
            return UIColor.yellow
        } else {
            return UIColor.gray
        }
    }
    
    class func stockColor(request: Basket) -> (String, UIColor){
        var status: String
        var color: UIColor
        if (request.stockCount == "-3"){
            status = String(format: "Товар %@ не найден", request.requestProduct)
            color = UIColor(red: 0.5, green: 0.2, blue: 0, alpha: 1) // Коричневый
        } else if (request.requestCount == "0"){
            status = String(format: "Неизвестно")
            color = .black
        } else if (request.stockCount == "-2"){
            status = String(format: "Превышено допустимое число проверок количества, попробуйте позднее")
            color = UIColor(red: 1, green: 0, blue: 1, alpha: 1) // Фиолетовый
        } else if (request.stockCount == "0"){
            status = String(format: "Нет")
            color = .red
        } else if (request.stockCount >= request.requestCount){
            status = String(format: "В наличии")
            color = .green
        } else if ((Int(request.stockCount) ?? 0) > 500 || request.stockCount == "-1"){
            status = String(format: "Частично доступно")
            color = UIColor(red: 1, green: 0.7, blue: 0, alpha: 1) // Оранжевый
        } else {
            status = String(format: "Доступно %@", request.stockCount)
            color = UIColor(red: 0.9, green: 0.9, blue: 0, alpha: 1) // Желтый
        }
        return (status, color)
    }
}
