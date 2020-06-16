//
//  MenuController.swift
//  EC-online
//
//  Created by Samir Azizov on 13/08/2019.
//  Updated by Sergey Lavrov on 02/04/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import UIKit

class MenuController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {
    
    //MARK: - Outlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    //MARK: - Array
    let imageArray = [
        UIImage(named: "request"),
        UIImage(named: "order"),
        UIImage(named: "basket"),
        UIImage(named: "unconfirmed"),
        UIImage(named: "reserved"),
        UIImage(named: "ordered"),
        UIImage(named: "canceled"),
        UIImage(named: "shipped")
    ]
    
    let nameArray = [
        "Проверка наличия товара",
        "Сделать заказ",
        "Корзина",
        "Неподтвержденные резервы",
        "Резервы",
        "Заказы",
        "Анулированные и просроченные счета",
        "История отгрузок"]
     
    let idArray = [
        "RequestCheckController",
        "RequestOrderController",
        "BasketController",
        "UnconfirmedController",
        "ReservedController",
        "OrderedController",
        "CanceledController",
        "ShippedController"]
    
    //MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.sideMenu(window: self, menuButton: menuButton)
    }

    //MARK: - Action
    @IBAction func logoutTapped(_ sender: UIButton) {
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
            Auth.shared.user.logout(
                successBlock: {
                    Auth.resetValuesOnLogout()
                    window.rootViewController = self.storyboard?.instantiateInitialViewController()
                    window.makeKeyAndVisible()
                }) { (error) in
                    Utilities.showAlert(strTitle: error, strMessage: nil, parent: self,
                                        OKButtonTitle: nil, CancelButtonTitle: nil,
                                        okBlock: nil, cancelBlock: nil)
            }
        }
    }
    
    //MARK: - Collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! MenuView
        cell.imgImage.image = imageArray[indexPath.row]
        cell.lblImageName.text! = nameArray[indexPath.row]
        if (collectionView.frame.width < 350){
            cell.lblImageName.font = UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.bold)
        } else {
            cell.lblImageName.font = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.bold)
        }
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 5
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let name = idArray[indexPath.row]
        let viewController = storyboard?.instantiateViewController(withIdentifier: name)
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
}

extension MenuController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2) - 5,
                      height: (collectionView.frame.height - 30) / 4)
    }
}
