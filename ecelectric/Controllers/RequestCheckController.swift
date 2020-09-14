//
//  RequestCheckController.swift
//  EC-online
//
//  Created by Samir Azizov on 05/09/2019.
//  Updated by Sergey Lavrov on 02/04/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import UIKit

class RequestCheckController: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    //MARK: - Variable
    var currentViewController: UIViewController?
    var searchType: Int = 0
    var product: String = ""
    var count: String = "1"
    var excelPath: String = ""
    var productColumn: String = "1"
    var countColumn: String = "2"
    var fullSearch: Bool = false

    //MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.sideMenu(window: self, menuButton: menuButton)
        
        var index: Int
        if searchType > 0 {
            index = searchType - 10
            self.segmentedControl.selectedSegmentIndex = index
        } else {
            index = self.segmentedControl.selectedSegmentIndex
        }
        
        if let vc = self.viewForSegmentIndex(index: index) {
            self.addChild(vc)
            self.contentView.addSubview(vc.view)
            self.currentViewController = vc
        }
    }
    
    //MARK: - Method
    func viewForSegmentIndex(index: Int) -> UIViewController? {
        if searchType > 0 {
            switch index {
            case 0:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "RequestByCodeCheckController") as! RequestByCodeCheckController
                vc.vProduct = self.product
                vc.vCount = self.count
                vc.vFullSearch = self.fullSearch
                return vc as UIViewController
            case 1:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "RequestFromExcelCheckController") as! RequestFromExcelCheckController
                vc.vExcelPath = self.excelPath
                vc.vProductColumn = self.productColumn
                vc.vCountColumn = self.countColumn
                vc.vFullSearch = self.fullSearch
                return vc as UIViewController
            default:
                return nil
            }
        } else {
            var vc: UIViewController?
            switch index {
            case 0:
                vc = self.storyboard?.instantiateViewController(withIdentifier: "RequestByCodeCheckController")
                return vc
            case 1:
                vc = self.storyboard?.instantiateViewController(withIdentifier: "RequestFromExcelCheckController")
                return vc
            default:
                return nil
            }
        }
    }
    
    //MARK: - Action
    @IBAction func switchViews(_ sender: UISegmentedControl) {
        if let vc = viewForSegmentIndex(index: sender.selectedSegmentIndex) {
            self.addChild(vc)
            self.transition(
                from: self.currentViewController!,
                to: vc,
                duration: 0.5,
                options: UIView.AnimationOptions.transitionFlipFromRight,
                animations: {
                    self.currentViewController!.view.removeFromSuperview()
                    vc.view.frame = self.contentView.bounds
                    self.contentView.addSubview(vc.view)
                },
                completion: { finished in
                    vc.didMove(toParent: self)
                    self.currentViewController!.removeFromParent()
                    self.currentViewController = vc
                }
            )
        }
    }
}
