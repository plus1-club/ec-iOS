//
//  Invoice.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 29/11/19.
//  Refactored by Sergey Lavrov on 10/07/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import UIKit

class Invoice: Codable {

    var number : String!
    var date : String!
    var sum : String!
    var status : String!
    var waybill : String!
    
    //MARK: - Method
    func invoicesFromResponse(response: NSDictionary) -> [Invoice]?{
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
            return invoices
        } catch {
            return nil
        }
    }
    
    //MARK: - API
    func getUnconfirmedList(isShowLoader: Bool,
                            successBlock :@escaping (_ invoices : [Invoice]) -> (),
                            errorBlock :@escaping (_ error : String) -> ())  {
                
        let type = Constants.REQUEST_TYPE.GET
        let url = Constants.SERVICES.GET_UNCONFIRMED_LIST

        ServiceManager.shared.processServiceCall(
            serviceURL: url, parameters: nil, showLoader: isShowLoader, requestType: type, filePath: nil,
            successBlock: { (response) in
                if let statusKey = response.value(forKey: "success") as? Int {
                    if statusKey != 1 {
                        DispatchQueue.main.async {
                            if let errormessage = response.value(forKey: "message") as? String{
                                errorBlock(errormessage)
                            }
                        }
                    } else {
                        let invoices = self.invoicesFromResponse(response: response)
                        DispatchQueue.main.async {
                            if (invoices != nil) {
                                successBlock(invoices!)
                            } else {
                                errorBlock(Constants.MESSAGES.ERROR_ON_READ_DATA_FROM_RESPONSE)
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        errorBlock(Constants.MESSAGES.SOMETHING_WENT_WRONG)
                    }
                }
            },
            errorBlock: { (error) in
                print("error : \(error.localizedDescription)")
                DispatchQueue.main.async {
                    errorBlock(error.localizedDescription)
                }
            }
        )
    }
    
    func getReservedList(isShowLoader: Bool,
                         successBlock :@escaping (_ invoices : [Invoice]) -> (),
                         errorBlock :@escaping (_ error : String) -> ())  {
                
        let type = Constants.REQUEST_TYPE.GET
        let url = Constants.SERVICES.GET_RESERVED_LIST

        ServiceManager.shared.processServiceCall(
            serviceURL: url, parameters: nil, showLoader: isShowLoader, requestType: type, filePath: nil,
            successBlock: { (response) in
                if let statusKey = response.value(forKey: "success") as? Int {
                    if statusKey != 1 {
                        DispatchQueue.main.async {
                            if let errormessage = response.value(forKey: "message") as? String{
                                errorBlock(errormessage)
                            }
                        }
                    } else {
                         let invoices = self.invoicesFromResponse(response: response)
                        DispatchQueue.main.async {
                            if (invoices != nil) {
                                successBlock(invoices!)
                            } else {
                                errorBlock(Constants.MESSAGES.ERROR_ON_READ_DATA_FROM_RESPONSE)
                            }
                        }
                   }
                } else {
                    DispatchQueue.main.async {
                        errorBlock(Constants.MESSAGES.SOMETHING_WENT_WRONG)
                    }
                }
            },
            errorBlock: { (error) in
                print("error : \(error.localizedDescription)")
                DispatchQueue.main.async {
                    errorBlock(error.localizedDescription)
                }
            }
        )
    }
    
    func getOrderedList(isShowLoader: Bool,
                        successBlock :@escaping (_ invoices : [Invoice]) -> (),
                        errorBlock :@escaping (_ error : String) -> ())  {
                
        let type = Constants.REQUEST_TYPE.GET
        let url = Constants.SERVICES.GET_ORDERED_LIST

        ServiceManager.shared.processServiceCall(
            serviceURL: url, parameters: nil, showLoader: isShowLoader, requestType: type, filePath: nil,
            successBlock: { (response) in
                if let statusKey = response.value(forKey: "success") as? Int {
                    if statusKey != 1 {
                        DispatchQueue.main.async {
                            if let errormessage = response.value(forKey: "message") as? String{
                                errorBlock(errormessage)
                            }
                        }
                    } else {
                        let invoices = self.invoicesFromResponse(response: response)
                        DispatchQueue.main.async {
                            if (invoices != nil) {
                                successBlock(invoices!)
                            } else {
                                errorBlock(Constants.MESSAGES.ERROR_ON_READ_DATA_FROM_RESPONSE)
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        errorBlock(Constants.MESSAGES.SOMETHING_WENT_WRONG)
                    }
                }
            },
            errorBlock: { (error) in
                print("error : \(error.localizedDescription)")
                DispatchQueue.main.async {
                    errorBlock(error.localizedDescription)
                }
            }
        )
    }
    
    func getCanceledList(isShowLoader: Bool,
                         successBlock :@escaping (_ invoices : [Invoice]) -> (),
                         errorBlock :@escaping (_ error : String) -> ())  {
                
        let type = Constants.REQUEST_TYPE.GET
        let url = Constants.SERVICES.GET_CANCELED_LIST

        ServiceManager.shared.processServiceCall(
            serviceURL: url, parameters: nil, showLoader: isShowLoader, requestType: type, filePath: nil,
            successBlock: { (response) in
                if let statusKey = response.value(forKey: "success") as? Int {
                    if statusKey != 1 {
                        DispatchQueue.main.async {
                            if let errormessage = response.value(forKey: "message") as? String{
                                errorBlock(errormessage)
                            }
                        }
                    } else {
                        let invoices = self.invoicesFromResponse(response: response)
                        DispatchQueue.main.async {
                            if (invoices != nil) {
                                successBlock(invoices!)
                            } else {
                                errorBlock(Constants.MESSAGES.ERROR_ON_READ_DATA_FROM_RESPONSE)
                            }
                        }
                    }
            } else {
                DispatchQueue.main.async {
                    errorBlock(Constants.MESSAGES.SOMETHING_WENT_WRONG)
                    }
                }
            },
            errorBlock: { (error) in
                print("error : \(error.localizedDescription)")
                DispatchQueue.main.async {
                    errorBlock(error.localizedDescription)
                }
            }
        )
    }
    
    func getShippedList(isShowLoader: Bool,
                        successBlock :@escaping (_ invoices : [Invoice]) -> (),
                        errorBlock :@escaping (_ error : String) -> ())  {
                
        let type = Constants.REQUEST_TYPE.GET
        let url = Constants.SERVICES.GET_SHIPPED_LIST

        ServiceManager.shared.processServiceCall(
            serviceURL: url, parameters: nil, showLoader: isShowLoader, requestType: type, filePath: nil,
            successBlock: { (response) in
                if let statusKey = response.value(forKey: "success") as? Int {
                    if statusKey != 1 {
                        DispatchQueue.main.async {
                            if let errormessage = response.value(forKey: "message") as? String{
                                errorBlock(errormessage)
                            }
                        }
                    } else {
                        let invoices = self.invoicesFromResponse(response: response)
                        DispatchQueue.main.async {
                            if (invoices != nil) {
                                successBlock(invoices!)
                            } else {
                                errorBlock(Constants.MESSAGES.ERROR_ON_READ_DATA_FROM_RESPONSE)
                            }
                        }
                    }
            } else {
                DispatchQueue.main.async {
                    errorBlock(Constants.MESSAGES.SOMETHING_WENT_WRONG)
                    }
                }
            },
            errorBlock: { (error) in
                print("error : \(error.localizedDescription)")
                DispatchQueue.main.async {
                    errorBlock(error.localizedDescription)
                }
            }
        )
    }
}
