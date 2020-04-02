//
//  Constants.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 13/11/19.
//  Updated by Sergey Lavrov on 02/04/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import Foundation

class Constants {
    struct REQUEST_TYPE {
        static let GET = "GET"
        static let PUT = "PUT"
        static let DELETE = "DELETE"
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
            
        //Bucket
        static let GET_BUCKET = BASE_URL + "request/basket"
        static let UPDATE_BUCKET = BASE_URL + "request/basket"
        static let CLEAR_BUCKET = BASE_URL + "request/basket"
        static let GET_ITEM_BY_CODE = BASE_URL + "request/byCode"

        static let CREATE_ORDER = BASE_URL + "request/order"

        //Invoice
        static let GET_UNCONFIRMED_ORDERS = BASE_URL + "invoices/unconfirmed"
        static let GET_CANCELED_ORDERS = BASE_URL + "invoices/canceled"
        static let GET_ORDERED_LIST = BASE_URL + "invoices/ordered"
        static let GET_RESERVED_LIST = BASE_URL + "invoices/reserved"
        static let GET_SHIPPED_LIST = BASE_URL + "invoices/shipped"

    }
    
    struct MESSAGES {
        static let ENTER_VALID_LOGIN_DETAILS = "Please enter valid credentials"
        static let SOMETHING_WENT_WRONG = "Something went wrong !!"
        static let ERROR_ON_READ_DATA_FROM_RESPONSE   = "Something went wrong while fetching data, Please try again"
        static let ENTER_VALID_DETAILS = "Please enter valid details"
        static let PRINT_NOT_AVAILABLE = "Print is not available, Please try again!"

    }
}
