//
//  Basket.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 16/11/19.
//  Updated by Sergey Lavrov on 02/04/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import Foundation

class Basket: Codable  {
    //MARK: Properties
    var number : String!
    var product : String!
    var stockCount : String!
    var requestCount : String!
    var price : String!
    var sum : String!
    var isSelected: Bool!
    var stockStatus: String!
    
    //MARK: Get Bucket
    func getBucket(isShowLoader: Bool,
                   successBlock :@escaping (_ baskets : [Basket]) -> (),
                   errorBlock :@escaping (_ error : String) -> ())  {
                
        ServiceManager.shared.processServiceCall(serviceURL: Constants.SERVICES.GET_BUCKET, parameters: nil, showLoader: isShowLoader, requestType: Constants.REQUEST_TYPE.GET, successBlock: { (response) in
            
            if let statusKey = response.value(forKey: "success") as? Int {
                    if statusKey != 1 {
                        DispatchQueue.main.async {
                            if let errormessage = response.value(forKey: "message") as? String{
                                errorBlock(errormessage)
                            }
                        }
                    }
                    else {
                        var buckets : [Basket] = []
                        
                        do {
                            if let bucketArray = response.value(forKey: "data") as? Array<Any> {
                                
                                for bucketDict in bucketArray {
                                    let data = try JSONSerialization.data(withJSONObject: bucketDict, options: [])
                                    
                                    let jsonDecoder = JSONDecoder()
                                    
                                    let bucket = try jsonDecoder.decode(Basket.self, from: data)
                                    buckets.append(bucket)
                                }
                            }
                            
                            DispatchQueue.main.async {
                                                                
                                successBlock(buckets)
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
    
    //MARK: Update Bucket
    func updateBucket(buckets : [Basket],
                      successBlock :@escaping () -> (),
                      errorBlock :@escaping (_ error : String) -> ())  {
        
        var bucketDict = [[String : String]]()
        
        for bucket in buckets {
            bucketDict.append([
                "number" : bucket.number,
                "product" : bucket.product,
                "requestCount" : bucket.requestCount
            ])
        }
        
        let params = [
            "requests" : bucketDict
        ]
        
        ServiceManager.shared.processServiceCall(serviceURL: Constants.SERVICES.UPDATE_BUCKET, parameters: params as AnyObject, showLoader: true, requestType: Constants.REQUEST_TYPE.PUT, successBlock: { (response) in
            
            if let statusKey = response.value(forKey: "success") as? Int {
                    if statusKey != 1 {
                        DispatchQueue.main.async {
                            if let errormessage = response.value(forKey: "message") as? String{
                                errorBlock(errormessage)
                            }
                        }
                    }
                    else {
                        
                        DispatchQueue.main.async {
                            successBlock()
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
    
    //MARK: Clear Bucket
    func clearBucket(successBlock :@escaping () -> (),
                     errorBlock :@escaping (_ error : String) -> ())  {
        
        ServiceManager.shared.processServiceCall(serviceURL: Constants.SERVICES.CLEAR_BUCKET, parameters: nil, showLoader: true, requestType: Constants.REQUEST_TYPE.DELETE, successBlock: { (response) in
            
            if let statusKey = response.value(forKey: "success") as? Int {
                    if statusKey != 1 {
                        DispatchQueue.main.async {
                            if let errormessage = response.value(forKey: "message") as? String{
                                errorBlock(errormessage)
                            }
                        }
                    }
                    else {
                        
                        DispatchQueue.main.async {
                            successBlock()
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
    
    //MARK: Add Item To Bucket
    func addItemToBucket(buckets : [Basket],
                      successBlock :@escaping () -> (),
                      errorBlock :@escaping (_ error : String) -> ())  {
        
        var bucketDict = [[String : String]]()
        
        for bucket in buckets {
            bucketDict.append([
                "number" : bucket.number,
                "product" : bucket.product,
                "requestCount" : bucket.requestCount
            ])
        }
        
        let params = [
            "requests" : bucketDict
        ]
        
        ServiceManager.shared.processServiceCall(serviceURL: Constants.SERVICES.UPDATE_BUCKET, parameters: params as AnyObject, showLoader: true, requestType: Constants.REQUEST_TYPE.POST, successBlock: { (response) in
            
            if let statusKey = response.value(forKey: "success") as? Int {
                    if statusKey != 1 {
                        DispatchQueue.main.async {
                            if let errormessage = response.value(forKey: "message") as? String{
                                errorBlock(errormessage)
                            }
                        }
                    }
                    else {
                        
                        DispatchQueue.main.async {
                            successBlock()
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
    
    //MARK: Get Product By Code
    func getProductByCode(product: String,
                          count: String,
                          fullSearch: Bool,
                          successBlock :@escaping (_ buckets : [Basket]) -> (),
                          errorBlock :@escaping (_ error : String) -> ())  {
                
        let url = Constants.SERVICES.GET_ITEM_BY_CODE + String(format: "?product=%@&count=%@&fullsearch=%d", arguments: [product, count, fullSearch])

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
                        var buckets : [Basket] = []
                        
                        do {
                            if let bucketArray = response.value(forKey: "data") as? Array<Any> {
                                
                                for bucketDict in bucketArray {
                                    let data = try JSONSerialization.data(withJSONObject: bucketDict, options: [])
                                    
                                    let jsonDecoder = JSONDecoder()
                                    
                                    let bucket = try jsonDecoder.decode(Basket.self, from: data)
                                    buckets.append(bucket)
                                }
                            }
                            
                            DispatchQueue.main.async {
                                                                
                                successBlock(buckets)
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
    
    //MARK: Create Order
    func createOrder(buckets: [Basket],
                     comment: String,
                     successBlock :@escaping () -> (),
                     errorBlock :@escaping (_ error : String) -> ())  {
        
        var bucketDict = [[String : String]]()
        
        for bucket in buckets {
            bucketDict.append([
                "number" : bucket.number,
                "product" : bucket.product,
                "requestCount" : bucket.requestCount
            ])
        }
        
        let params = [
            "requests": bucketDict,
            "comment": comment
            ] as [String : Any]
        
        ServiceManager.shared.processServiceCall(serviceURL: Constants.SERVICES.CREATE_ORDER, parameters: params as AnyObject, showLoader: true, requestType: Constants.REQUEST_TYPE.POST, successBlock: { (response) in
            
            if let statusKey = response.value(forKey: "success") as? Int {
                    if statusKey != 1 {
                        DispatchQueue.main.async {
                            if let errormessage = response.value(forKey: "message") as? String{
                                errorBlock(errormessage)
                            }
                        }
                    }
                    else {
                        
                        DispatchQueue.main.async {
                            successBlock()
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
