//
//  Auth.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 13/11/19.
//  Updated by Sergey Lavrov on 02/04/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import Foundation

class Auth {

    //MARK: - Variable
    static let shared = Auth()
    let user = User()
    
    //MARK: - Constructor
    //This prevents others from using the default '()' initializer for this class.
    private init() {

    }
    
    //MARK: - Method
    class func resetValuesOnLogout() {
        Auth.shared.user.token = nil
        Constants.DEFAULTS.SELF.removeObject(forKey: Constants.DEFAULTS.ID)
        Constants.DEFAULTS.SELF.removeObject(forKey: Constants.DEFAULTS.PASSWORD)
        Constants.DEFAULTS.SELF.synchronize()
    }
}
