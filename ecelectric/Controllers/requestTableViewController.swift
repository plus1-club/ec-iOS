//
//  requestTableViewController.swift
//  ecelectric
//
//  Created by Sam on 11/09/2019.
//  Copyright © 2019 Samir Azizov. All rights reserved.
//

import UIKit

class requestTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var requestTableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var grandTotal: UILabel!
    
    /*
    let invoiceNumber1 = [("1.Schneider MGU5.418.25ZD 2 USB Зарядное устройство, 2.1A, беж"), ("2.Legrand 774420 Розетка 2К+3 нем.ст.VALENA белый"), ("3.Schneider PA16-004D 1ая розетка с заземлением, со штор."), ("4.Legrand 10954 Суппорт/Рамка 4 М Dpl Кр.65"), ("5.Legrand 10954 Суппорт/Рамка 4 М Dpl Кр.65")]
    let invoiceAmount1 = [("Сумма: 7 970,98"), ("Сумма: 6 172,76"), ("Сумма: 8 817,87"), ("Сумма: 27 967,00"), ("Сумма: 356,73")]
    let itemPrice1 = [("Цена: 2141,81"), ("Цена: 151,65"), ("Цена: 159,29"), ("Цена: 162,74"), ("Цена: 162,74")]
    */
    var buckets = [Bucket]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestTableView.delegate = self
        requestTableView.dataSource = self
        requestTableView.rowHeight = 70
        setupSideMenu()
        
        getBucket()
    }
    
    //MARK: APIs
    func getBucket() {
        Bucket().getBucket(successBlock: { (buckets) in
            self.buckets = buckets
            self.requestTableView.reloadData()
            self.calculateGrandTotal()
        }) { (error) in
            Utilities.showAlert(strTitle: error, strMessage: nil, parent: self, OKButtonTitle: nil, CancelButtonTitle: nil, okBlock: nil, cancelBlock: nil)

        }
    }
    
    
    func setupSideMenu() {
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            revealViewController().rightViewRevealWidth = 275
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    //MARK: IBActions
    @IBAction func clearTapped(_ sender: Button) {
        Bucket().clearBucket(successBlock: {
            self.buckets.removeAll()
            self.requestTableView.reloadData()
            
            Utilities.showAlert(strTitle: "Bucket successfully cleared !!", strMessage: nil, parent: self, OKButtonTitle: nil, CancelButtonTitle: nil, okBlock: nil, cancelBlock: nil)

        }) { (error) in
            Utilities.showAlert(strTitle: error, strMessage: nil, parent: self, OKButtonTitle: nil, CancelButtonTitle: nil, okBlock: nil, cancelBlock: nil)
        }
    }
    
    @IBAction func addTapped(_ sender: Button) {
        let navController = self.storyboard?.instantiateViewController(withIdentifier: "checkAvailableProductNavigation") as! UINavigationController
        self.revealViewController()?.setFront(navController, animated: true)

    }
    
    @IBAction func checkoutTapped(_ sender: Button) {
        Bucket().updateBucket(buckets: self.buckets, successBlock: {
            Utilities.showAlert(strTitle: "Bucket successfully updated !!", strMessage: nil, parent: self, OKButtonTitle: nil, CancelButtonTitle: nil, okBlock: nil, cancelBlock: nil)

        }) { (error) in
            Utilities.showAlert(strTitle: error, strMessage: nil, parent: self, OKButtonTitle: nil, CancelButtonTitle: nil, okBlock: nil, cancelBlock: nil)
        }
    }
    
    @IBAction func deleteTapped(_ sender: Button) {
        self.buckets.remove(at: sender.tag)
        requestTableView.deleteRows(at: [IndexPath(row: sender.tag, section: 0)], with: .fade)
    }
    
    //MARK: TableView DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buckets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let requestTableCell = tableView.dequeueReusableCell(withIdentifier: "requestTableCell", for: indexPath as IndexPath) as! requestTableViewCell
        
        let bucket = self.buckets[indexPath.row]
        requestTableCell.invoiceNumber1.text = String(format: "%@.%@", arguments: [bucket.number, bucket.product])
        
        requestTableCell.qty.tag = indexPath.row
        requestTableCell.qty.text = bucket.requestCount
        requestTableCell.qty.delegate = self
        requestTableCell.invoiceAmount1.text = String(format: "Сумма: %@ %@", arguments: [bucket.stockCount, bucket.sum])
        requestTableCell.itemPrice1.text = String(format: "Цена: %@", arguments: [bucket.price])
        
        requestTableCell.deleteItem.tag = indexPath.row
        requestTableCell.deleteItem.removeTarget(self, action: #selector(deleteTapped(_:)), for: .touchUpInside)
        requestTableCell.deleteItem.addTarget(self, action: #selector(deleteTapped(_:)), for: .touchUpInside)
        
        return requestTableCell
    }
    
    func calculateGrandTotal() {
        var total: Double = 0
        for bucket in buckets {
            total += (Double(bucket.requestCount) ?? 0) * (Double(bucket.price) ?? 0)
        }
        
        grandTotal.text = String(format: "Итого: %.2f", arguments: [total])
    }
}

extension requestTableViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let bucket = self.buckets[textField.tag]

        bucket.requestCount = textField.text
        
        calculateGrandTotal()
    }
}
