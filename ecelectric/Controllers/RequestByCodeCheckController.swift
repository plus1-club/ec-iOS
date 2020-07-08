//
//  RequestByCodeCheckController.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 03/12/19.
//  Refactored by Sergey Lavrov on 02/07/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import UIKit

class RequestByCodeCheckController: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var product: UITextField!
    @IBOutlet weak var quantity: UITextField!
    @IBOutlet weak var isAdvanceSearch: Button!

    let document = UIDocumentInteractionController()

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        document.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Method
    func isValidInput() -> Bool {
        if Utilities.isValidString(str: product.text) &&
            Utilities.isValidString(str: quantity.text) {
            return true
        }
        else {
            Utilities.showAlert(strTitle: Constants.MESSAGES.ENTER_VALID_DETAILS, strMessage: nil, parent: self, OKButtonTitle: nil, CancelButtonTitle: nil, okBlock: nil, cancelBlock: nil)
            return false
        }
    }
    
    // MARK: - Action
    @IBAction func isAdvanceSearchTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func checkTapped(_ sender: Button) {
        /*
        if isValidInput() {
            Basket().getProductByCode(product: product.text!, count: quantity.text!, fullSearch: !isAdvanceSearch.isSelected, successBlock: { (searchArray) in

                let controller = self.storyboard?.instantiateViewController(withIdentifier: "SearchController") as! SearchController
                controller.searchArray = searchArray
                self.navigationController?.pushViewController(controller, animated: true)
                
            }) { (error) in
                 Utilities.showAlert(strTitle: error, strMessage: nil, parent: self, OKButtonTitle: nil, CancelButtonTitle: nil, okBlock: nil, cancelBlock: nil)
            }
        }
         */
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "CheckByCode") && isValidInput() {
            Basket().getProductByCode(product: product.text!,
                                      count: quantity.text!,
                                      fullSearch: !isAdvanceSearch.isSelected,
              successBlock: { (searchArray) in
                let navigation = segue.destination as! UINavigationController
                let controller = navigation.viewControllers.first as! SearchController
                controller.searchArray = searchArray
                controller.searchTableView.reloadData()
                controller.refreshControl.endRefreshing()},
              errorBlock: { (error) in
                Utilities.alertMessage(parent: self, message: error)});
        }
    }
    
    @IBAction func downloadStock(_ sender: UIButton) {
        Basket().downloadStockBalance(successBlock: { (fileURL) in
            self.storeAndShare(url: fileURL)
        }) { (error) in
            Utilities.alertMessage(parent: self, message: error)
        }
    }
}

// MARK: -
extension RequestByCodeCheckController {
    func share(url: URL){
        document.url = url
        document.uti = typeIdentifier(url: url) ?? "public.data, public.content"
        document.name = localizedName(url: url) ?? url.lastPathComponent
        document.presentPreview(animated: true)
    }
    
    func storeAndShare(url: URL){
        URLSession.shared.dataTask(with: url){
            data, response, error in
            guard let data = data, error == nil else { return }
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(response?.suggestedFilename ?? "file.xls")
            do {
                try data.write(to: tempURL)
            } catch {
                print(error)
            }
            DispatchQueue.main.async {
                self.share(url: tempURL)
            }
        }.resume()
    }
    
    func typeIdentifier(url: URL) -> String? {
        return (try? url.resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    
    func localizedName(url: URL) -> String? {
        return (try? url.resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
}

// MARK: - 
extension RequestByCodeCheckController: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let navVC = self.navigationController else {
            return self
        }
        return navVC
    }
}
