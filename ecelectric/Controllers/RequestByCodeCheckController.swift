//
//  RequestByCodeCheckController.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 03/12/19.
//  Refactored by Sergey Lavrov on 02/07/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import UIKit

class RequestByCodeCheckController: UIViewController, UINavigationControllerDelegate {

    // MARK: - Outlet
    @IBOutlet weak var product: UITextField!
    @IBOutlet weak var count: UITextField!
    @IBOutlet weak var fullSearch: UIButton!
    @IBOutlet weak var storeLink: UIButton!
    
    //MARK: - Variable
    var vProduct: String = ""
    var vCount: String = "1"
    var vFullSearch: Bool = false
    let document = UIDocumentInteractionController()

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        document.delegate = self
        self.product.text = vProduct
        self.count.text = vCount
        self.fullSearch.isSelected = vFullSearch
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "CheckByCode") && isValidInput() {
            LoadingOverlay.shared.showOverlay(view: self.view)
            Basket().searchByCode(
                product: product.text!,
                count: count.text!,
                fullSearch: !fullSearch.isSelected,
                successBlock: { (searchArray) in
                    let navigation = segue.destination as! UINavigationController
                    let controller = navigation.viewControllers.first as! SearchController
                    controller.searchArray = searchArray
                    controller.setVariants()
                    controller.searchTableView.reloadData()
                    controller.refreshControl.endRefreshing()
                    controller.backNavigation = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController ?? UINavigationController()
                    let backController = self.storyboard?.instantiateViewController(withIdentifier: "RequestCheckController") ?? RequestCheckController()
                    controller.backNavigation.pushViewController(backController, animated: true)
                    controller.searchType = 10
                    controller.product = self.product.text!
                    controller.count = self.count.text!
                    controller.fullSearch = self.fullSearch.isSelected
                    controller.title = "Проверка наличия товара"
                    LoadingOverlay.shared.hideOverlayView()
                },
                errorBlock: { (error) in
                    LoadingOverlay.shared.hideOverlayView()
                    Utilities.alertMessage(parent: self, message: error)
                }
            )
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Method
    func isValidInput() -> Bool {
        if Utilities.isValidString(str: product.text) &&
            Utilities.isValidString(str: count.text) {
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
    
    @IBAction func checkTapped(_ sender: Button) {}
    
    @IBAction func downloadStock(_ sender: UIButton) {
        self.storeLink.isEnabled = false
        LoadingOverlay.shared.showOverlay(view: self.view)
        Basket().downloadStockBalance(
            successBlock: {(fileURL) in self.storeAndShare(url: fileURL)},
            errorBlock: {(error) in Utilities.alertMessage(parent: self, message: error)}
        )
    }
}

// MARK: -
extension RequestByCodeCheckController {
    func share(url: URL){
        document.url = url
        document.uti = typeIdentifier(url: url) ?? "public.data, public.content"
        document.name = localizedName(url: url) ?? url.lastPathComponent
        document.presentPreview(animated: true)
        LoadingOverlay.shared.hideOverlayView()
        self.storeLink.isEnabled = true
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
