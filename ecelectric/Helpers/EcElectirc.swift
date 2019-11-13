//
//  EcElectirc.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 13/11/19.
//  Copyright © 2019 Samir Azizov. All rights reserved.
//

import Foundation

class EcElectirc {

    static let shared = EcElectirc()
    let user = User()
    
    //This prevents others from using the default '()' initializer for this class.
    private init() {

    }
}
