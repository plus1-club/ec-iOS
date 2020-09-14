//
//  User.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 13/11/19.
//  Refactored by Sergey Lavrov on 10/07/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import Foundation

class User {
    
    var token : String!
    
    //MARK: - API
    func login(id: String,
               password: String,
               successBlock :@escaping () -> (),
               errorBlock :@escaping (_ error : String) -> ())  {
        
        let type = Constants.REQUEST_TYPE.GET
        let url = Constants.SERVICES.LOGIN
            + String(format: "?login=%@&password=%@", arguments: [id, password])
        
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
                            if let token = data["user_token"]  as? String {
                                Auth.shared.user.token = token
                            }
                            DispatchQueue.main.async {
                                successBlock()
                            }
                        } else {
                            DispatchQueue.main.async {
                                errorBlock(Constants.MESSAGES.SOMETHING_WENT_WRONG)
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
    
    func logout(successBlock :@escaping () -> (),
                errorBlock :@escaping (_ error : String) -> ())  {

        let type = Constants.REQUEST_TYPE.GET
        let url = Constants.SERVICES.LOGOUT

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
}
