//
//  SideMenuController.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 13/11/19.
//  Refactored by Sergey Lavrov on 16/06/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import UIKit

class SideMenuController: UITableViewController {
  
    // MARK: - Variable
    let exit = 9
    let idArray = [
        "RequestCheckController",
        "RequestOrderController",
        "BasketController",
        "UnconfirmedController",
        "ReservedController",
        "OrderedController",
        "CanceledController",
        "ShippedController"]

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - TableView

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Exit
        if indexPath.row == exit {
            if  let app = UIApplication.shared.delegate as? AppDelegate,
                let window = app.window {
                Auth.shared.user.logout(successBlock: {
                    Auth.resetValuesOnLogout()
                    window.rootViewController = self.storyboard?.instantiateInitialViewController()
                    window.makeKeyAndVisible()
                }) { (error) in
                    Utilities.showAlert(strTitle: error, strMessage: nil, parent: self, OKButtonTitle: nil, CancelButtonTitle: nil, okBlock: nil, cancelBlock: nil)
                }
            }
        }
    }
}
