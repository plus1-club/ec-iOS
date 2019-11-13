//
//  Constants.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 13/11/19.
//  Copyright © 2019 Samir Azizov. All rights reserved.
//

import Foundation

class Constants {
    struct REQUEST_TYPE {
        static let GET = "GET"
        static let POST = "POST"
    }
    
    struct USER_DEFAULTS {
        static let OBJ_USER_DEFAULT          = UserDefaults.standard
        static let ID                        = "id"
        static let PASSWORD                  = "password"
                
    }
    
    struct SERVICES {
        // To Check internet availibility
        static let HOST_URL = "www.google.com"
        
        static let BASE_URL = "https://www.ec-electric.ru/api/v1/"
        static let LOGIN = BASE_URL + "user/enter"
        static let LOGOUT = BASE_URL + "user/exit"
    }
    
    struct MESSAGES {
        static let ENTER_VALID_LOGIN_DETAILS = "Please enter valid credentials"
        static let SOMETHING_WENT_WRONG = "Something went wrong !!"
    }
}
