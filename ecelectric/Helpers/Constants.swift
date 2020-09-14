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
        // URL
        static let HOST_URL = "www.google.com" // To Check internet availibility
        static let BASE_URL = "https://www.ec-electric.ru/api/v1/"
        
        // User
        static let LOGIN = BASE_URL + "user/enter"
        static let LOGOUT = BASE_URL + "user/exit"
 
        // Search
        static let SEARCH_BY_CODE = BASE_URL + "request/byCode"
        static let SEARCH_FROM_EXCEL = BASE_URL + "request/fromExcel"

        // Basket
        static let GET_BUCKET = BASE_URL + "request/basket"
        static let UPDATE_BUCKET = BASE_URL + "request/basket"
        static let CLEAR_BUCKET = BASE_URL + "request/basket"
        static let CREATE_ORDER = BASE_URL + "request/order"

        // Download
        static let DOWNLOAD_STOCK_BALANCE = BASE_URL + "request/download/stock"
        static let DOWNLOAD_EXAMPLE = BASE_URL + "request/download/example"

        // Invoice
        static let GET_UNCONFIRMED_LIST = BASE_URL + "invoices/unconfirmed"
        static let GET_RESERVED_LIST = BASE_URL + "invoices/reserved"
        static let GET_ORDERED_LIST = BASE_URL + "invoices/ordered"
        static let GET_CANCELED_LIST = BASE_URL + "invoices/canceled"
        static let GET_SHIPPED_LIST = BASE_URL + "invoices/shipped"

        // Details
        static let GET_UNCONFIRMED_DETAILS = BASE_URL + "invoices/%@/unconfirmed"
        static let GET_RESERVED_DETAILS = BASE_URL + "invoices/%@/reserved"
        static let GET_ORDERED_DETAILS = BASE_URL + "invoices/%@/ordered"
        static let GET_CANCELED_DETAILS = BASE_URL + "invoices/%@/canceled"
        static let GET_SHIPPED_DETAILS = BASE_URL + "invoices/%@/shipped"
        static let DOWNLOAD_INVOICE_PRINT = BASE_URL + "invoices/%@/print"
    }
    
    struct MESSAGES {
        static let SOMETHING_WENT_WRONG = "Что-то пошло не так"
        static let INTERNET_NOT_AVAILABLE = "Limited or no internet connectivity. Please try again."
        static let ERROR_ON_READ_DATA_FROM_RESPONSE   = "При получении данных произошёл сбой. Пожалуйста попробуйте снова"
        static let ENTER_VALID_LOGIN_DETAILS = "Пожалуйста введите корректные логин и пароль"
        static let ENTER_VALID_DETAILS = "Пожалуйста введите корректные данные"
        static let PRINT_NOT_AVAILABLE = "Счет не доступен. Попробуйте снова"
        static let FILE_NOT_AVAILABLE = "Файл не доступен. Попробуйте снова"
    }
    
    struct COLORS {
        static let BROWN = UIColor(hex: "#9A6855")!
        static let RED = UIColor(hex: "#F44336")!
        static let ORANGE = UIColor(hex: "#FF8036")!
        static let YELLOW = UIColor(hex: "#FFC107")!
        static let GREEN = UIColor(hex: "#4CAF50")!
        static let BLUE = UIColor(hex: "#0080FF")!
        static let VIOLET = UIColor(hex: "#AA80FF")!
        static let BLACK = UIColor(hex: "#000000")!
        static let DARK = UIColor(hex: "#676767")!
        static let GRAY = UIColor(hex: "#888888")!
        static let WHITE = UIColor(hex: "#FFFFFF")!
    }
}
