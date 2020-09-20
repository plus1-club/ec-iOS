//
//  Basket.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 16/11/19.
//  Refactored by Sergey Lavrov on 10/07/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import Foundation

class Basket: Codable  {
    
    var number : String!
    var product : String!
    var stockCount : String!
    var requestCount : String!
    var price : String!
    var sum : String!
    var unit : String!
    var isSelected: Bool!
    var multiplicity: String!
    var requestProduct: String!
    var variantsCount: Int!
    
    //MARK: - Method
    func paramsFromBasket(basket: [Basket], comment: String?) -> AnyObject{
        var dict = [[String : String]]()
        
        for item in basket {
            dict.append([
                "number" : item.number,
                "product" : item.product,
                "requestCount" : item.requestCount
            ])
        }
        
        let params: [String : Any]
        if (comment == nil){
            params = [
                "requests" : dict
            ]
        } else {
            params = [
                "comment" : comment!
            ]
        }
        
        return params as AnyObject
    }
    
    func basketFromResponse(response: NSDictionary) -> [Basket]?{
        var basket : [Basket] = []
        do {
            if let responseData = response.value(forKey: "data") as? Array<Any> {
                for dict in responseData {
                    let data = try JSONSerialization.data(withJSONObject: dict, options: [])
                    let jsonDecoder = JSONDecoder()
                    let item = try jsonDecoder.decode(Basket.self, from: data)
                    basket.append(item)
                }
            }
            return basket
        } catch {
            return nil
        }
    }
    
    //MARK: - Search API
    func searchByCode(product: String,
                      count: String,
                      fullSearch: Bool,
                      successBlock :@escaping (_ buckets : [Basket]) -> (),
                      errorBlock :@escaping (_ error : String) -> ())  {
                
        let type = Constants.REQUEST_TYPE.GET
        let url = Constants.SERVICES.SEARCH_BY_CODE
            + String(format: "?product=%@&count=%@&fullsearch=%@",
                     arguments: [product, count, (fullSearch ? "true" : "false")])

        ServiceManager.shared.processServiceCall(
            serviceURL: url, parameters: nil, requestType: type, filePath: nil,
            successBlock: { (response) in
                if let statusKey = response.value(forKey: "success") as? Int {
                    if statusKey != 1 {
                        DispatchQueue.main.async {
                            if let errormessage = response.value(forKey: "message") as? String{
                                errorBlock(errormessage)
                            }
                        }
                    } else {
                        let basket = self.basketFromResponse(response: response)
                        DispatchQueue.main.async {
                            if (basket != nil) {
                                successBlock(basket!)
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
    
    func searchFromExcel(excelPath: String,
                         productColumn: String,
                         countColumn: String,
                         fullSearch: Bool,
                         successBlock :@escaping (_ buckets : [Basket]) -> (),
                         errorBlock :@escaping (_ error : String) -> ())  {
                
        let type = Constants.REQUEST_TYPE.POST
        let url = Constants.SERVICES.SEARCH_FROM_EXCEL
        let params = [
            "productColumn": productColumn,
            "countColumn": countColumn,
            "fullsearch": (fullSearch ? "true" : "false")
        ] as AnyObject

        ServiceManager.shared.processServiceCall(
            serviceURL: url, parameters: params, requestType: type, filePath: excelPath,
            successBlock: { (response) in
                if let statusKey = response.value(forKey: "success") as? Int {
                    if statusKey != 1 {
                        DispatchQueue.main.async {
                            if let errormessage = response.value(forKey: "message") as? String{
                                errorBlock(errormessage)
                            }
                        }
                    } else {
                        let basket = self.basketFromResponse(response: response)
                        DispatchQueue.main.async {
                            if (basket != nil) {
                                successBlock(basket!)
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
    
    //MARK: - Basket API
    func getBasket(successBlock :@escaping (_ baskets : [Basket]) -> (),
                   errorBlock :@escaping (_ error : String) -> ())  {
       
        let type = Constants.REQUEST_TYPE.GET
        let url = Constants.SERVICES.GET_BUCKET

        ServiceManager.shared.processServiceCall(
            serviceURL: url, parameters: nil, requestType: type, filePath: nil,
            successBlock: { (response) in
                if let statusKey = response.value(forKey: "success") as? Int {
                    if statusKey != 1 {
                        DispatchQueue.main.async {
                            if let errormessage = response.value(forKey: "message") as? String{
                                errorBlock(errormessage)
                            }
                        }
                    } else {
                        let basket = self.basketFromResponse(response: response)
                        DispatchQueue.main.async {
                            if (basket != nil) {
                                successBlock(basket!)
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
    
    func addToBasket(basketArray : [Basket],
                     successBlock :@escaping (_ baskets : [Basket]) -> (),
                     errorBlock :@escaping (_ error : String) -> ())  {
        
        let type = Constants.REQUEST_TYPE.POST
        let url = Constants.SERVICES.UPDATE_BUCKET
        let params = paramsFromBasket(basket: basketArray, comment: nil)
        
        ServiceManager.shared.processServiceCall(
            serviceURL: url, parameters: params, requestType: type, filePath: nil,
            successBlock: { (response) in
                if let statusKey = response.value(forKey: "success") as? Int {
                    if statusKey != 1 {
                        DispatchQueue.main.async {
                            if let errormessage = response.value(forKey: "message") as? String{
                                errorBlock(errormessage)
                            }
                        }
                    } else {
                        let basket = self.basketFromResponse(response: response)
                        DispatchQueue.main.async {
                            if (basket != nil) {
                                successBlock(basket!)
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
    
    func updateBasket(basketArray : [Basket],
                      successBlock :@escaping () -> (),
                      errorBlock :@escaping (_ error : String) -> ())  {
        
        let type = Constants.REQUEST_TYPE.PUT
        let url = Constants.SERVICES.UPDATE_BUCKET
        let params = paramsFromBasket(basket: basketArray, comment: nil)

        ServiceManager.shared.processServiceCall(
            serviceURL: url, parameters: params, requestType: type, filePath: nil,
            successBlock: { (response) in
                if let statusKey = response.value(forKey: "success") as? Int {
                    if statusKey != 1 {
                        DispatchQueue.main.async {
                            if let errormessage = response.value(forKey: "message") as? String{
                                errorBlock(errormessage)
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            successBlock()
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
    
    func clearBasket(successBlock :@escaping () -> (),
                     errorBlock :@escaping (_ error : String) -> ())  {
        
        let type = Constants.REQUEST_TYPE.DELETE
        let url = Constants.SERVICES.CLEAR_BUCKET

        ServiceManager.shared.processServiceCall(
            serviceURL: url, parameters: nil, requestType: type, filePath: nil,
            successBlock: { (response) in
                if let statusKey = response.value(forKey: "success") as? Int {
                    if statusKey != 1 {
                        DispatchQueue.main.async {
                            if let errormessage = response.value(forKey: "message") as? String{
                                errorBlock(errormessage)
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            successBlock()
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
    
    func createOrder(basketArray: [Basket],
                     comment: String,
                     successBlock :@escaping (_ order: String) -> (),
                     errorBlock :@escaping (_ error : String) -> ())  {
        
        let type = Constants.REQUEST_TYPE.POST
        var url = Constants.SERVICES.CREATE_ORDER
        if (!comment.isEmpty){
            url += String(format:"?comment=%@", arguments: [comment])
        }
        let params = paramsFromBasket(basket: basketArray, comment: comment)
        
        ServiceManager.shared.processServiceCall(
            serviceURL: url, parameters: params, requestType: type, filePath: nil,
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
                            if let order = data["number"] as? String  {
                                DispatchQueue.main.async {
                                    successBlock(order)
                                }
                            } else {
                                DispatchQueue.main.async {
                                    errorBlock(Constants.MESSAGES.SOMETHING_WENT_WRONG)
                                }
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
    
    //MARK: - Download API
    func downloadStockBalance(successBlock :@escaping (_ fileURL : URL) -> (),
                              errorBlock :@escaping (_ error : String) -> ()) {
        
        let type = Constants.REQUEST_TYPE.GET
        let url = Constants.SERVICES.DOWNLOAD_STOCK_BALANCE

        ServiceManager.shared.processServiceCall(
            serviceURL: url, parameters: nil, requestType: type, filePath: nil,
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
                            if let filePath = data["product"] as? String, let url = URL(string: filePath)  {
                                DispatchQueue.main.async {
                                    successBlock(url)
                                }
                            } else {
                                DispatchQueue.main.async {
                                    errorBlock(Constants.MESSAGES.FILE_NOT_AVAILABLE)
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                errorBlock(Constants.MESSAGES.FILE_NOT_AVAILABLE)
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

    func downloadExample(successBlock :@escaping (_ fileURL : URL) -> (),
                         errorBlock :@escaping (_ error : String) -> ()) {
        
        let type = Constants.REQUEST_TYPE.GET
        let url = Constants.SERVICES.DOWNLOAD_EXAMPLE

        ServiceManager.shared.processServiceCall(
            serviceURL: url, parameters: nil, requestType: type, filePath: nil,
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
                            if let filePath = data["product"] as? String, let url = URL(string: filePath)  {
                                DispatchQueue.main.async {
                                    successBlock(url)
                                }
                            } else {
                                DispatchQueue.main.async {
                                    errorBlock(Constants.MESSAGES.FILE_NOT_AVAILABLE)
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                errorBlock(Constants.MESSAGES.FILE_NOT_AVAILABLE)
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
