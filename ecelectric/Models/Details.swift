//
//  Details.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 29/11/19.
//  Refactored by Sergey Lavrov on 10/07/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import UIKit

class Details: Codable {

    var id : String!
    var product : String!
    var count : String!
    var unit : String!
    var price : String!
    var sum : String!
    var available : String!
    var delivery : String!

    //MARK: - Method
    func detailsFromResponse(response: NSDictionary) -> [Details]?{
        var details : [Details] = []
        do {
            if let invoiceArray = response.value(forKey: "data") as? Array<Any> {
                for dict in invoiceArray {
                    let data = try JSONSerialization.data(withJSONObject: dict, options: [])
                    let jsonDecoder = JSONDecoder()
                    let item = try jsonDecoder.decode(Details.self, from: data)
                    details.append(item)
                }
            }
            return details
        } catch {
            return nil
        }
   }

    //MARK: - API
    func getUnconfirmedDetails(accountNo: String,
                               successBlock :@escaping (_ invoicesDetails : [Details]) -> (),
                               errorBlock :@escaping (_ error : String) -> ())  {
                
        let type = Constants.REQUEST_TYPE.GET
        let url = String(format: Constants.SERVICES.GET_UNCONFIRMED_DETAILS,
                         arguments: [accountNo])

        ServiceManager.shared.processServiceCall(
            serviceURL: url, parameters: nil, showLoader: true, requestType: type, filePath: nil,
            successBlock: { (response) in
                if let statusKey = response.value(forKey: "success") as? Int {
                    if statusKey != 1 {
                        DispatchQueue.main.async {
                            if let errormessage = response.value(forKey: "message") as? String{
                                errorBlock(errormessage)
                            }
                        }
                    } else {
                        let details = self.detailsFromResponse(response: response)
                        DispatchQueue.main.async {
                            if (details != nil) {
                                successBlock(details!)
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
    
    func getReservedDetails(accountNo: String,
                            successBlock :@escaping (_ invoicesDetails : [Details]) -> (),
                            errorBlock :@escaping (_ error : String) -> ())  {
                
        let type = Constants.REQUEST_TYPE.GET
        let url = String(format: Constants.SERVICES.GET_RESERVED_DETAILS,
                         arguments: [accountNo])

        ServiceManager.shared.processServiceCall(
            serviceURL: url, parameters: nil, showLoader: true, requestType: type, filePath: nil,
            successBlock: { (response) in
                if let statusKey = response.value(forKey: "success") as? Int {
                    if statusKey != 1 {
                        DispatchQueue.main.async {
                            if let errormessage = response.value(forKey: "message") as? String{
                                errorBlock(errormessage)
                            }
                        }
                    } else {
                        let details = self.detailsFromResponse(response: response)
                        DispatchQueue.main.async {
                            if (details != nil) {
                                successBlock(details!)
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
    
    func getOrderedDetails(accountNo: String,
                           successBlock :@escaping (_ invoicesDetails : [Details]) -> (),
                           errorBlock :@escaping (_ error : String) -> ())  {
                
        let type = Constants.REQUEST_TYPE.GET
        let url = String(format: Constants.SERVICES.GET_ORDERED_DETAILS,
                         arguments: [accountNo])

        ServiceManager.shared.processServiceCall(
            serviceURL: url, parameters: nil, showLoader: true, requestType: type, filePath: nil,
            successBlock: { (response) in
                if let statusKey = response.value(forKey: "success") as? Int {
                    if statusKey != 1 {
                        DispatchQueue.main.async {
                            if let errormessage = response.value(forKey: "message") as? String{
                                errorBlock(errormessage)
                            }
                        }
                    } else {
                        let details = self.detailsFromResponse(response: response)
                        DispatchQueue.main.async {
                            if (details != nil) {
                                successBlock(details!)
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
    
    func getCanceledDetails(accountNo: String,
                            successBlock :@escaping (_ invoicesDetails : [Details]) -> (),
                            errorBlock :@escaping (_ error : String) -> ())  {
                
        let type = Constants.REQUEST_TYPE.GET
        let url = String(format: Constants.SERVICES.GET_CANCELED_DETAILS,
                         arguments: [accountNo])

        ServiceManager.shared.processServiceCall(
            serviceURL: url, parameters: nil, showLoader: true, requestType: type, filePath: nil,
            successBlock: { (response) in
                if let statusKey = response.value(forKey: "success") as? Int {
                    if statusKey != 1 {
                        DispatchQueue.main.async {
                            if let errormessage = response.value(forKey: "message") as? String{
                                errorBlock(errormessage)
                            }
                        }
                    } else {
                        let details = self.detailsFromResponse(response: response)
                        DispatchQueue.main.async {
                            if (details != nil) {
                                successBlock(details!)
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
    
    func getShippedDetails(accountNo: String,
                           successBlock :@escaping (_ invoicesDetails : [Details]) -> (),
                           errorBlock :@escaping (_ error : String) -> ())  {
                
        let type = Constants.REQUEST_TYPE.GET
        let url = String(format: Constants.SERVICES.GET_SHIPPED_DETAILS,
                         arguments: [accountNo])

        ServiceManager.shared.processServiceCall(
            serviceURL: url, parameters: nil, showLoader: true, requestType: type, filePath: nil,
            successBlock: { (response) in
                if let statusKey = response.value(forKey: "success") as? Int {
                    if statusKey != 1 {
                        DispatchQueue.main.async {
                            if let errormessage = response.value(forKey: "message") as? String{
                                errorBlock(errormessage)
                            }
                        }
                    } else {
                        let details = self.detailsFromResponse(response: response)
                        DispatchQueue.main.async {
                            if (details != nil) {
                                successBlock(details!)
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
    
    func getInvoicePrint(accountNo: String,
                         successBlock :@escaping (_ fileURL : URL) -> (),
                         errorBlock :@escaping (_ error : String) -> ())  {
                
        let type = Constants.REQUEST_TYPE.GET
        let url = String(format: Constants.SERVICES.GET_SHIPPED_DETAILS,
                         arguments: [accountNo])

        ServiceManager.shared.processServiceCall(
            serviceURL: url, parameters: nil, showLoader: true, requestType: type, filePath: nil,
            successBlock: { (response) in
                if let statusKey = response.value(forKey: "success") as? Int {
                    if statusKey != 1 {
                        DispatchQueue.main.async {
                            if let errormessage = response.value(forKey: "message") as? String{
                                errorBlock(errormessage)
                            }
                        }
                    } else {
                        if let data = response.value(forKey: "data") as? [String: Any] {
                            if let filePath = data["file"] as? String, let url = URL(string: filePath)  {
                                DispatchQueue.main.async {
                                    successBlock(url)
                                }
                            } else {
                                DispatchQueue.main.async {
                                    errorBlock(Constants.MESSAGES.PRINT_NOT_AVAILABLE)
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                errorBlock(Constants.MESSAGES.PRINT_NOT_AVAILABLE)
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
