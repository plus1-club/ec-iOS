//
//  MenuViewController.swift
//  ec-electric
//
//  Created by Sam on 05/08/2019.
//  Copyright © 2019 +1. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var itemMenuArray: [Menu] = {
        var blankMenu = Menu()
        blankMenu.imageName = "check_existence"
        blankMenu.name = "Проверка наличия товара"
        
        
        var blankMenu2 = Menu()
        blankMenu2.imageName = "make_order"
        blankMenu2.name = "Сделать заказ"
        
        
        var blankMenu3 = Menu()
        blankMenu3.imageName = "cart"
        blankMenu3.name = "Корзина"
        
        
        var blankMenu4 = Menu()
        blankMenu4.imageName = "nepodtv"
        blankMenu4.name = "Неподтвержденные заказы"
        
        var blankMenu5 = Menu()
        blankMenu5.imageName = "reserves"
        blankMenu5.name = "Резервы"
        
        
        var blankMenu6 = Menu()
        blankMenu6.imageName = "orders"
        blankMenu6.name = "Заказы"
        
        
        var blankMenu7 = Menu()
        blankMenu7.imageName = "annul"
        blankMenu7.name = "Анулированные и просроченные счета"
        
        
        var blankMenu8 = Menu()
        blankMenu8.imageName = "history"
        blankMenu8.name = "История отгрузок"
        
        
        return[blankMenu, blankMenu2, blankMenu3, blankMenu4, blankMenu5,  blankMenu6, blankMenu7, blankMenu8]
        
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension MenuViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemMenuArray.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as? MenuCollectionViewCell{
            
            itemCell.menu = itemMenuArray[indexPath.row]
            
            itemCell.layer.borderColor = UIColor.red.cgColor
            itemCell.layer.borderWidth = 1
            itemCell.layer.cornerRadius = 5
            
            return itemCell
        }
        return UICollectionViewCell()
    }
    
    /*func collectionView(collectioView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemPath indexPath: NSIndexPath) -> CGSize{
        let size = CGSize(width: 145, height: 90)
        return size
    }*/
    
}
