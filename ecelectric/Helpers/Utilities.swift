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
            return Constants.COLORS.RED
        } else if (available == "В наличии"){
            return Constants.COLORS.GREEN
        } else if (available.hasPrefix("Есть только")){
            return Constants.COLORS.YELLOW
        } else {
            return Constants.COLORS.GRAY
        }
    }
    
    class func stockColor(request: Basket) -> (String, UIColor){
        var status: String
        var color: UIColor
        if (request.stockCount == "-3"){
            status = String(format: "Товар %@ не найден", request.requestProduct)
            color = Constants.COLORS.BROWN
        } else if (request.requestCount == "0"){
            status = String(format: "Неизвестно")
            color = Constants.COLORS.GRAY
        } else if (request.stockCount == "-2"){
            status = String(format: "Превышено допустимое число проверок количества, попробуйте позднее")
            color = Constants.COLORS.VIOLET
        } else if (request.stockCount == "0"){
            status = String(format: "Нет")
            color = Constants.COLORS.RED
        } else if (Int.init(request.stockCount)! >= Int.init(request.requestCount)!){
            status = String(format: "В наличии")
            color = Constants.COLORS.GREEN
        } else if ((Int(request.stockCount) ?? 0) > 500 || request.stockCount == "-1"){
            status = String(format: "Частично доступно")
            color = Constants.COLORS.ORANGE
        } else {
            status = String(format: "Доступно %@", request.stockCount)
            color = Constants.COLORS.YELLOW
        }
        return (status, color)
    }
}

extension UIColor {
    public convenience init?(hex: String){
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#"){
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            if (hexColor.count == 8) {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                if scanner.scanHexInt64(&hexNumber){
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            } else if (hexColor.count == 6) {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                if scanner.scanHexInt64(&hexNumber){
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                    a = 1
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        return nil
    }
}
