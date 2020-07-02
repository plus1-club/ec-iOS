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
        static let POST = "POST"
        static let PUT = "PUT"
        static let DELETE = "DELETE"
    }
    
    struct DEFAULTS {
        static let SELF     = UserDefaults.standard
        static let SAVED    = "isSaved"
        static let ID       = "id"
        static let PASSWORD = "password"
    }
    
    struct SERVICES {
        // To Check internet availibility
        static let HOST_URL = "www.google.com"
        static let BASE_URL = "https://www.ec-electric.ru/api/v1/"
        
        //Login
        static let LOGIN = BASE_URL + "user/enter"
        static let LOGOUT = BASE_URL + "user/exit"
            
        //Basket
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
        static let SOMETHING_WENT_WRONG = "Что-то пошло не так"
        static let ERROR_ON_READ_DATA_FROM_RESPONSE   = "При получении данных произошёл сбой. Пожалуйста попробуйте снова"
        static let ENTER_VALID_LOGIN_DETAILS = "Пожалуйста введите корректные логин и пароль"
        static let ENTER_VALID_DETAILS = "Пожалуйста введите корректные данные"
        static let PRINT_NOT_AVAILABLE = "Счет не доступен. Попробуйте снова"
        static let FILE_NOT_AVAILABLE = "Файл не доступен. Попробуйте снова"
    }
}
