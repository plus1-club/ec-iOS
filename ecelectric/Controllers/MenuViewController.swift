//
//  ViewController.swift
//  TestCollectionView
//
//  Created by Sam on 13/08/2019.
//  Copyright © 2019 Samir Azizov. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let imageArray = [UIImage(named: "request"), UIImage(named: "order"), UIImage(named: "basket"), UIImage(named: "unconfirmed"), UIImage(named: "reserved"), UIImage(named: "ordered"), UIImage(named: "canceled"), UIImage(named: "shipped")]
    
    let nameArray = ["Проверка наличия товара", "Сделать заказ", "Корзина", "Неподтвержденные заказы" ,"Резервы", "Заказы", "Анулированные и просроченные счета", "История отгрузок"]
    
    let arrayOfIds = ["proverka", "orderByRequest", "requestTable", "nepodtv", "reserved", "orders", "сanceled", "shipped"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sideMenu()
    }

    func sideMenu() {
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            revealViewController().rightViewRevealWidth = 275
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! MenuCollectionViewCell
        cell.imgImage.image = imageArray[indexPath.row]
        cell.lblImageName.text! = nameArray[indexPath.row]
        
        cell.layer.borderColor = UIColor.red.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 5
        
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    print("test is good")
    let name = arrayOfIds[indexPath.row]
    let viewController = storyboard?.instantiateViewController(withIdentifier: name)
    self.navigationController?.pushViewController(viewController!, animated: true)
    
    }
    
}

