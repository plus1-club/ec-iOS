//
//  RequestFromExcelOrderController.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 03/12/19.
//  Updated by Sergey Lavrov on 02/04/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import UIKit

class RequestFromExcelOrderController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

//        scrollView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func checkTapped(_ sender: Button) {
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "SearchController") as! SearchController
        self.navigationController?.pushViewController(controller, animated: true)
     }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

//extension RequestFromExcelOrderController: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
//    }
//}

