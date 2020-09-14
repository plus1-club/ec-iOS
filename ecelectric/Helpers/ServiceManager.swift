//
//  ServiceManager.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 13/11/19.
//  Updated by Sergey Lavrov on 02/04/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import Foundation
import MobileCoreServices

class ServiceManager: NSObject {
    static let shared = ServiceManager()
    let REQUEST_TIME_OUT = 120.0
    
    func processServiceCall(serviceURL: String,
                            parameters: AnyObject?,
                            requestType : String,
                            filePath : String?,
                            successBlock: @escaping (_ responseDict:NSDictionary) -> (),
                            errorBlock: @escaping (_ error:NSError) -> Void)
    {
        if Reachability.isConnectedToNetwork() {
            
//            if showLoader == true {
//                DispatchQueue.main.async(execute: { () -> Void in
//                    iLoader.shared.show()
//                })
//            }
            
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
                
                if (filePath != nil)
                {
                    let boundary = generateBoundaryString()
                    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

                    var fileURL = URL(string: filePath!)!;
                    if fileURL.isFileURL == false {
                        fileURL = URL(fileURLWithPath: fileURL.absoluteString)
                    }
                    
                    request.httpBody = try createBody(with: parameters as? [String : String], filePathKey: "excel", urls: [fileURL], boundary: boundary)

                }
                
                let session = URLSession.shared
                //                session.configuration.timeoutIntervalForRequest = 120
                
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                    if (error != nil) {
                        print(error ?? "")
                        DispatchQueue.main.async(execute: { () -> Void in
                            errorBlock(error! as NSError)
                        })
                    } else {
                        do {
                            print("\((serviceURL as NSString).lastPathComponent)")
                            print("Response: \(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)")
                            let jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                            print("Response as Dictionary : \(jsonDictionary)")
                            DispatchQueue.main.async(execute: { () -> Void in
                                successBlock(jsonDictionary)
                            })
                        } catch let myJSONError {
                            print("\((serviceURL as NSString).lastPathComponent) myJSONError : \(myJSONError)")
                            DispatchQueue.main.async(execute: { () -> Void in
                                errorBlock(myJSONError as NSError)
                            })
                        }
                    }
                })
                dataTask.resume()
            }
            catch let error {
                print("Error in service call : \(error)")
            }
        }
        else {
            let err = NSError(domain: "", code: 501, userInfo:
                [NSLocalizedDescriptionKey : Constants.MESSAGES.INTERNET_NOT_AVAILABLE])
            errorBlock(err)
        }
    }
    
    /// Create body of the `multipart/form-data` request
    ///
    /// - parameter parameters:   The optional dictionary containing keys and values to be passed to web service.
    /// - parameter filePathKey:  The optional field name to be used when uploading files. If you supply paths, you must supply filePathKey, too.
    /// - parameter urls:         The optional array of file URLs of the files to be uploaded.
    /// - parameter boundary:     The `multipart/form-data` boundary.
    ///
    /// - returns:                The `Data` of the body of the request.

    private func createBody(with parameters: [String: String]?, filePathKey: String, urls: [URL], boundary: String) throws -> Data {
        var body = Data()

        parameters?.forEach { (key, value) in
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }

        for url in urls {
            let filename = url.lastPathComponent
            let data = try Data(contentsOf: url)
            let mimetype = mimeType(for: filename)

            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
            body.append("Content-Type: \(mimetype)\r\n\r\n")
            body.append(data)
            body.append("\r\n")
        }

        body.append("--\(boundary)--\r\n")
        return body
    }

    /// Create boundary string for multipart/form-data request
    ///
    /// - returns:            The boundary string that consists of "Boundary-" followed by a UUID string.

    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }

    /// Determine mime type on the basis of extension of a file.
    ///
    /// This requires `import MobileCoreServices`.
    ///
    /// - parameter path:         The path of the file for which we are going to determine the mime type.
    ///
    /// - returns:                Returns the mime type if successful. Returns `application/octet-stream` if unable to determine mime type.

    private func mimeType(for path: String) -> String {
        let pathExtension = URL(fileURLWithPath: path).pathExtension as NSString

        guard
            let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, nil)?.takeRetainedValue(),
            let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue()
        else {
            return "application/octet-stream"
        }

        return mimetype as String
    }
}

extension Data {

    /// Append string to Data
    ///
    /// Rather than littering my code with calls to `data(using: .utf8)` to convert `String` values to `Data`, this wraps it in a nice convenient little extension to Data. This defaults to converting using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `Data`.

    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
