//
//  ServiceManager.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 13/11/19.
//  Updated by Sergey Lavrov on 02/04/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import Foundation
import iLoader

class ServiceManager: NSObject {
    static let shared = ServiceManager()
    let REQUEST_TIME_OUT = 120.0
    
    func processServiceCall(serviceURL: String,
                            parameters: AnyObject?,
                            showLoader : Bool,
                            requestType : String,
                            successBlock: @escaping (_ responseDict:NSDictionary) -> (),
                            errorBlock: @escaping (_ error:NSError) -> Void)
    {
        if Reachability.isConnectedToNetwork() {
            
            if showLoader == true {
                DispatchQueue.main.async(execute: { () -> Void in
                    iLoader.shared.show()
                })
            }
            
            var headers = [
                "content-type": "application/json",
                "Accept": "application/json",
                "cache-control": "no-cache",
            ]
            
            if Utilities.isValidString(str: Auth.shared.user.token) {
                headers["user_token"] = Auth.shared.user.token
            }
            print("headers : \(headers)")
            do {
                print(requestType)
                print(serviceURL)
                
                var postData : Data? = nil
                if parameters != nil {
                    let jsonData: NSData = try JSONSerialization.data(withJSONObject: parameters!, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
                    print("\((serviceURL as NSString).lastPathComponent) ")
                    print("Parameter : \(NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String)")

                    postData = try JSONSerialization.data(withJSONObject: parameters!, options:JSONSerialization.WritingOptions.prettyPrinted)
                }
                
                let url: URL
                if let encodedURL = serviceURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
                    url = NSURL(string: encodedURL)! as URL
                } else {
                    url = NSURL(fileURLWithPath: serviceURL) as URL
                }
                let request = NSMutableURLRequest(url: url,
                                                  cachePolicy: .useProtocolCachePolicy,
                                                  timeoutInterval: REQUEST_TIME_OUT)
                request.httpMethod = requestType
                request.allHTTPHeaderFields = headers
                request.httpBody = (postData != nil ? postData : nil)
                
                let session = URLSession.shared
                //                session.configuration.timeoutIntervalForRequest = 120
                
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                    if (error != nil) {
                        print(error ?? "")
                        DispatchQueue.main.async(execute: { () -> Void in
                            if showLoader == true {
                                iLoader.shared.hide()
                            }
                            errorBlock(error! as NSError)
                        })
                    } else {
                        do {
                            print("\((serviceURL as NSString).lastPathComponent)")
                            print("Response: \(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)")
                            let jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                            print("Response as Dictionary : \(jsonDictionary)")
                            DispatchQueue.main.async(execute: { () -> Void in
                                if showLoader == true {
                                    iLoader.shared.hide()
                                }
                                successBlock(jsonDictionary)
                            })
                        } catch let myJSONError {
                            print("\((serviceURL as NSString).lastPathComponent) myJSONError : \(myJSONError)")
                            DispatchQueue.main.async(execute: { () -> Void in
                                if showLoader == true {
                                    iLoader.shared.hide()
                                }
                                errorBlock(myJSONError as NSError)
                            })
                        }
                    }
                })
                dataTask.resume()
            }
            catch let error {
                if showLoader == true {
                    iLoader.shared.hide()
                }
                print("Error in service call : \(error)")
            }
        }
        else {
            let err = NSError(domain: "", code: 501, userInfo:
                [NSLocalizedDescriptionKey : Constants.MESSAGES.INTERNET_NOT_AVAILABLE])
            errorBlock(err)
        }
    }
}
