//
//  InvoiceDetails.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 29/11/19.
//  Copyright © 2019 Samir Azizov. All rights reserved.
//

import UIKit

class InvoiceDetails: Codable {
    //MARK: Properties
    var id : String!
    var product : String!
    var count : String!
    var price : String!
    var sum : String!
    var available : String!

    //MARK: Get unconfirmed orders
    func getUnconfirmedOrderDetails(accountNo: String,
                                    successBlock :@escaping (_ invoicesDetails : [InvoiceDetails]) -> (),
                                    errorBlock :@escaping (_ error : String) -> ())  {
                
        let url = String(format: "%@invoices/%@/unconfirmed?user-token=%@", arguments: [Constants.SERVICES.BASE_URL, accountNo, EcElectirc.shared.user.token])

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
                        var invoicesDetails : [InvoiceDetails] = []
                        
                        do {
                            if let invoiceArray = response.value(forKey: "data") as? Array<Any> {
                                
                                for dict in invoiceArray {
                                    let data = try JSONSerialization.data(withJSONObject: dict, options: [])
                                    
                                    let jsonDecoder = JSONDecoder()
                                    
                                    let invoice = try jsonDecoder.decode(InvoiceDetails.self, from: data)
                                    invoicesDetails.append(invoice)
                                }
                            }
                            
                            DispatchQueue.main.async {
                                successBlock(invoicesDetails)
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
    func getCancelOrderDetails(accountNo: String,
                                    successBlock :@escaping (_ invoicesDetails : [InvoiceDetails]) -> (),
                                    errorBlock :@escaping (_ error : String) -> ())  {
                
        let url = String(format: "%@invoices/%@/canceled?user-token=%@", arguments: [Constants.SERVICES.BASE_URL, accountNo, EcElectirc.shared.user.token])

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
                        var invoicesDetails : [InvoiceDetails] = []
                        
                        do {
                            if let invoiceArray = response.value(forKey: "data") as? Array<Any> {
                                
                                for dict in invoiceArray {
                                    let data = try JSONSerialization.data(withJSONObject: dict, options: [])
                                    
                                    let jsonDecoder = JSONDecoder()
                                    
                                    let invoice = try jsonDecoder.decode(InvoiceDetails.self, from: data)
                                    invoicesDetails.append(invoice)
                                }
                            }
                            
                            DispatchQueue.main.async {
                                successBlock(invoicesDetails)
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
    
    //MARK: Get ordered item details
    func getOrderedItemDetails(accountNo: String,
                               successBlock :@escaping (_ invoicesDetails : [InvoiceDetails]) -> (),
                               errorBlock :@escaping (_ error : String) -> ())  {
                
        let url = String(format: "%@invoices/%@/ordered?user-token=%@", arguments: [Constants.SERVICES.BASE_URL, accountNo, EcElectirc.shared.user.token])

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
                        var invoicesDetails : [InvoiceDetails] = []
                        
                        do {
                            if let invoiceArray = response.value(forKey: "data") as? Array<Any> {
                                
                                for dict in invoiceArray {
                                    let data = try JSONSerialization.data(withJSONObject: dict, options: [])
                                    
                                    let jsonDecoder = JSONDecoder()
                                    
                                    let invoice = try jsonDecoder.decode(InvoiceDetails.self, from: data)
                                    invoicesDetails.append(invoice)
                                }
                            }
                            
                            DispatchQueue.main.async {
                                successBlock(invoicesDetails)
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
    
    //MARK: Get reserved item details
    func getReservedItemDetails(accountNo: String,
                               successBlock :@escaping (_ invoicesDetails : [InvoiceDetails]) -> (),
                               errorBlock :@escaping (_ error : String) -> ())  {
                
        let url = String(format: "%@invoices/%@/reserved?user-token=%@", arguments: [Constants.SERVICES.BASE_URL, accountNo, EcElectirc.shared.user.token])

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
                        var invoicesDetails : [InvoiceDetails] = []
                        
                        do {
                            if let invoiceArray = response.value(forKey: "data") as? Array<Any> {
                                
                                for dict in invoiceArray {
                                    let data = try JSONSerialization.data(withJSONObject: dict, options: [])
                                    
                                    let jsonDecoder = JSONDecoder()
                                    
                                    let invoice = try jsonDecoder.decode(InvoiceDetails.self, from: data)
                                    invoicesDetails.append(invoice)
                                }
                            }
                            
                            DispatchQueue.main.async {
                                successBlock(invoicesDetails)
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
    
    //MARK: Get shipped item details
    func getShippedItemDetails(accountNo: String,
                               successBlock :@escaping (_ invoicesDetails : [InvoiceDetails]) -> (),
                               errorBlock :@escaping (_ error : String) -> ())  {
                
        let url = String(format: "%@invoices/%@/shipped?user-token=%@", arguments: [Constants.SERVICES.BASE_URL, accountNo, EcElectirc.shared.user.token])

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
                        var invoicesDetails : [InvoiceDetails] = []
                        
                        do {
                            if let invoiceArray = response.value(forKey: "data") as? Array<Any> {
                                
                                for dict in invoiceArray {
                                    let data = try JSONSerialization.data(withJSONObject: dict, options: [])
                                    
                                    let jsonDecoder = JSONDecoder()
                                    
                                    let invoice = try jsonDecoder.decode(InvoiceDetails.self, from: data)
                                    invoicesDetails.append(invoice)
                                }
                            }
                            
                            DispatchQueue.main.async {
                                successBlock(invoicesDetails)
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
    
}
