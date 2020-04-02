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

    static let shared = Auth()
    let user = User()
    
    //This prevents others from using the default '()' initializer for this class.
    private init() {

    }
}
