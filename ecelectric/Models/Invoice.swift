//
//  Invoice.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 29/11/19.
//  Copyright © 2019 Samir Azizov. All rights reserved.
//

import UIKit

class Invoice: Codable {
    //MARK: Properties
    var number : String!
    var date : String!
    var sum : String!
    var status : String!
    
    
    //MARK: Get unconfirmed orders
    func getUnconfirmedOrders(isShowLoader: Bool,
                              successBlock :@escaping (_ invoices : [Invoice]) -> (),
                              errorBlock :@escaping (_ error : String) -> ())  {
                
        let url = Constants.SERVICES.GET_UNCONFIRMED_ORDERS + String(format: "?user-token=%@", arguments: [EcElectirc.shared.user.token])

        ServiceManager.shared.processServiceCall(serviceURL: url, parameters: nil, showLoader: isShowLoader, requestType: Constants.REQUEST_TYPE.GET, successBlock: { (response) in
            
            if let statusKey = response.value(forKey: "success") as? Int {
                    if statusKey != 1 {
                        DispatchQueue.main.async {
                            if let errormessage = response.value(forKey: "message") as? String{
                                errorBlock(errormessage)
                            }
                        }
                    }
                    else {
                        var invoices : [Invoice] = []
                        
                        do {
                            if let invoiceArray = response.value(forKey: "data") as? Array<Any> {
                                
                                for dict in invoiceArray {
                                    let data = try JSONSerialization.data(withJSONObject: dict, options: [])
                                    
                                    let jsonDecoder = JSONDecoder()
                                    
                                    let invoice = try jsonDecoder.decode(Invoice.self, from: data)
                                    invoices.append(invoice)
                                }
                            }
                            
                            DispatchQueue.main.async {
                                successBlock(invoices)
                            }
                        }
                        catch {
                            DispatchQueue.main.async {
                                errorBlock(Constants.MESSAGES.ERROR_ON_READ_DATA_FROM_RESPONSE)
                            }
                        }
                    }
            }
            else {
                DispatchQueue.main.async {
                    errorBlock(Constants.MESSAGES.SOMETHING_WENT_WRONG)
                }
            }


        }) { (error) in
            print("error : \(error.localizedDescription)")
            DispatchQueue.main.async {
                errorBlock(error.localizedDescription)
            }
        }
    }
    
    //MARK: Get canceled orders
    func getCanceledOrders(isShowLoader: Bool,
                           successBlock :@escaping (_ invoices : [Invoice]) -> (),
                           errorBlock :@escaping (_ error : String) -> ())  {
                
        let url = Constants.SERVICES.GET_CANCELED_ORDERS + String(format: "?user-token=%@", arguments: [EcElectirc.shared.user.token])

        ServiceManager.shared.processServiceCall(serviceURL: url, parameters: nil, showLoader: isShowLoader, requestType: Constants.REQUEST_TYPE.GET, successBlock: { (response) in
            
            if let statusKey = response.value(forKey: "success") as? Int {
                    if statusKey != 1 {
                        DispatchQueue.main.async {
                            if let errormessage = response.value(forKey: "message") as? String{
                                errorBlock(errormessage)
                            }
                        }
                    }
                    else {
                        var invoices : [Invoice] = []
                        
                        do {
                            if let invoiceArray = response.value(forKey: "data") as? Array<Any> {
                                
                                for dict in invoiceArray {
                                    let data = try JSONSerialization.data(withJSONObject: dict, options: [])
                                    
                                    let jsonDecoder = JSONDecoder()
                                    
                                    let invoice = try jsonDecoder.decode(Invoice.self, from: data)
                                    invoices.append(invoice)
                                }
                            }
                            
                            DispatchQueue.main.async {
                                successBlock(invoices)
                            }
                        }
                        catch {
                            DispatchQueue.main.async {
                                errorBlock(Constants.MESSAGES.ERROR_ON_READ_DATA_FROM_RESPONSE)
                            }
                        }
                    }
            }
            else {
                DispatchQueue.main.async {
                    errorBlock(Constants.MESSAGES.SOMETHING_WENT_WRONG)
                }
            }


        }) { (error) in
            print("error : \(error.localizedDescription)")
            DispatchQueue.main.async {
                errorBlock(error.localizedDescription)
            }
        }
    }
    
    //MARK: Get ordered list
    func getOrderedItemList(isShowLoader: Bool,
                            successBlock :@escaping (_ invoices : [Invoice]) -> (),
                            errorBlock :@escaping (_ error : String) -> ())  {
                
        let url = Constants.SERVICES.GET_ORDERED_LIST + String(format: "?user-token=%@", arguments: [EcElectirc.shared.user.token])

        ServiceManager.shared.processServiceCall(serviceURL: url, parameters: nil, showLoader: isShowLoader, requestType: Constants.REQUEST_TYPE.GET, successBlock: { (response) in
            
            if let statusKey = response.value(forKey: "success") as? Int {
                    if statusKey != 1 {
                        DispatchQueue.main.async {
                            if let errormessage = response.value(forKey: "message") as? String{
                                errorBlock(errormessage)
                            }
                        }
                    }
                    else {
                        var invoices : [Invoice] = []
                        
                        do {
                            if let invoiceArray = response.value(forKey: "data") as? Array<Any> {
                                
                                for dict in invoiceArray {
                                    let data = try JSONSerialization.data(withJSONObject: dict, options: [])
                                    
                                    let jsonDecoder = JSONDecoder()
                                    
                                    let invoice = try jsonDecoder.decode(Invoice.self, from: data)
                                    invoices.append(invoice)
                                }
                            }
                            
                            DispatchQueue.main.async {
                                successBlock(invoices)
                            }
                        }
                        catch {
                            DispatchQueue.main.async {
                                errorBlock(Constants.MESSAGES.ERROR_ON_READ_DATA_FROM_RESPONSE)
                            }
                        }
                    }
            }
            else {
                DispatchQueue.main.async {
                    errorBlock(Constants.MESSAGES.SOMETHING_WENT_WRONG)
                }
            }


        }) { (error) in
            print("error : \(error.localizedDescription)")
            DispatchQueue.main.async {
                errorBlock(error.localizedDescription)
            }
        }
    }
    
    //MARK: Get reserved Item list
    func getReservedItemList(isShowLoader: Bool,
                            successBlock :@escaping (_ invoices : [Invoice]) -> (),
                            errorBlock :@escaping (_ error : String) -> ())  {
                
        let url = Constants.SERVICES.GET_RESERVED_LIST + String(format: "?user-token=%@", arguments: [EcElectirc.shared.user.token])

        ServiceManager.shared.processServiceCall(serviceURL: url, parameters: nil, showLoader: isShowLoader, requestType: Constants.REQUEST_TYPE.GET, successBlock: { (response) in
            
            if let statusKey = response.value(forKey: "success") as? Int {
                    if statusKey != 1 {
                        DispatchQueue.main.async {
                            if let errormessage = response.value(forKey: "message") as? String{
                                errorBlock(errormessage)
                            }
                        }
                    }
                    else {
                        var invoices : [Invoice] = []
                        
                        do {
                            if let invoiceArray = response.value(forKey: "data") as? Array<Any> {
                                
                                for dict in invoiceArray {
                                    let data = try JSONSerialization.data(withJSONObject: dict, options: [])
                                    
                                    let jsonDecoder = JSONDecoder()
                                    
                                    let invoice = try jsonDecoder.decode(Invoice.self, from: data)
                                    invoices.append(invoice)
                                }
                            }
                            
                            DispatchQueue.main.async {
                                successBlock(invoices)
                            }
                        }
                        catch {
                            DispatchQueue.main.async {
                                errorBlock(Constants.MESSAGES.ERROR_ON_READ_DATA_FROM_RESPONSE)
                            }
                        }
                    }
            }
            else {
                DispatchQueue.main.async {
                    errorBlock(Constants.MESSAGES.SOMETHING_WENT_WRONG)
                }
            }


        }) { (error) in
            print("error : \(error.localizedDescription)")
            DispatchQueue.main.async {
                errorBlock(error.localizedDescription)
            }
        }
    }
    
    //MARK: Get invoice PDF
    func getInvoicePrint(accountNo: String,
                         successBlock :@escaping (_ fileURL : URL) -> (),
                         errorBlock :@escaping (_ error : String) -> ())  {
                
        let url = String(format: "%@invoices/%@/download?user-token=%@", arguments: [Constants.SERVICES.BASE_URL, accountNo, EcElectirc.shared.user.token])

        ServiceManager.shared.processServiceCall(serviceURL: url, parameters: nil, showLoader: true, requestType: Constants.REQUEST_TYPE.GET, successBlock: { (response) in
            
            if let statusKey = response.value(forKey: "success") as? Int {
                if statusKey != 1 {
                    DispatchQueue.main.async {
                        if let errormessage = response.value(forKey: "message") as? String{
                            errorBlock(errormessage)
                        }
                    }
                }
                else {
                    
                    if let data = response.value(forKey: "data") as? [String: Any] {
                        if let filePath = data["file"] as? String, let url = URL(string: filePath)  {
                            
                            DispatchQueue.main.async {
                                successBlock(url)
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                errorBlock(Constants.MESSAGES.PRINT_NOT_AVAILABLE)
                            }
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            errorBlock(Constants.MESSAGES.PRINT_NOT_AVAILABLE)
                        }
                    }
                    
                }
            }
            else {
                DispatchQueue.main.async {
                    errorBlock(Constants.MESSAGES.SOMETHING_WENT_WRONG)
                }
            }


        }) { (error) in
            print("error : \(error.localizedDescription)")
            DispatchQueue.main.async {
                errorBlock(error.localizedDescription)
            }
        }
    }
    
}
