//
//  RequestFromExcelOrderController.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 03/12/19.
//  Refactored by Sergey Lavrov on 02/07/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import UIKit
import MobileCoreServices

class RequestFromExcelOrderController: UIViewController, UIDocumentPickerDelegate, UINavigationControllerDelegate {

    // MARK: - Outlet
    @IBOutlet weak var file: UITextField!
    @IBOutlet weak var productColumn: UITextField!
    @IBOutlet weak var countColumn: UITextField!
    @IBOutlet weak var fullSearch: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var exampleLink: UIButton!
    
    //MARK: - Variable
    var vExcelPath: String = ""
    var vProductColumn: String = "1"
    var vCountColumn: String = "2"
    var vFullSearch: Bool = false
    let document = UIDocumentInteractionController()

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        document.delegate = self
        file.text = vExcelPath
        productColumn.text = vProductColumn
        countColumn.text = vCountColumn
        fullSearch.isSelected = vFullSearch
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "OrderFromExcel") {
            LoadingOverlay.shared.showOverlay(view: self.view)
            Basket().searchFromExcel(
                excelPath: file.text!,
                productColumn: productColumn.text!,
                countColumn: countColumn.text!,
                fullSearch: !fullSearch.isSelected,
                successBlock: { (searchArray) in
                    let navigation = segue.destination as! UINavigationController
                    let controller = navigation.viewControllers.first as! SearchController
                    controller.searchArray = searchArray
                    controller.setVariants()
                    controller.searchTableView.reloadData()
                    controller.refreshControl.endRefreshing()
                    controller.backNavigation = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController ?? UINavigationController()
                    let backController = self.storyboard?.instantiateViewController(withIdentifier: "RequestOrderController") ?? RequestOrderController()
                    controller.backNavigation.pushViewController(backController, animated: true)
                    controller.searchType = 21
                    controller.excelPath = self.file.text!
                    controller.productColumn = self.productColumn.text!
                    controller.countColumn = self.countColumn.text!
                    controller.fullSearch = self.fullSearch.isSelected
                    controller.title = "Сделать заказ"
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
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let myURL = urls.first?.path
        file.text = myURL
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
                dismiss(animated: true, completion: nil)
    }

    // MARK: - Action
    @IBAction func checkTapped(_ sender: Button) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "SearchController") as! SearchController
        self.navigationController?.pushViewController(controller, animated: true)
     }
    
    
    @IBAction func selectFile(_ sender: UIButton) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeSpreadsheet as String, "com.microsoft.excel.xls","org.openxmlformats.spreadsheetml.sheet"], in: .import)
        documentPicker.delegate = self
        self.present(documentPicker, animated: true)
    }
    
    @IBAction func downloadExample(_ sender: UIButton) {
        self.exampleLink.isEnabled = false
        LoadingOverlay.shared.showOverlay(view: self.view)
        Basket().downloadExample(
            successBlock: { (fileURL) in self.storeAndShare(url: fileURL)},
            errorBlock: { (error) in Utilities.alertMessage(parent: self, message: error)}
        )
    }
}

// MARK: -
extension RequestFromExcelOrderController {
    func share(url: URL){
        document.url = url
        document.uti = "com.microsoft.excel.xls"
        //document.uti = typeIdentifier(url: url) ?? "public.data, public.content"
        document.name = localizedName(url: url) ?? url.lastPathComponent
        document.presentPreview(animated: true)
        LoadingOverlay.shared.hideOverlayView()
        self.exampleLink.isEnabled = true
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
extension RequestFromExcelOrderController: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let navVC = self.navigationController else {
            return self
        }
        return navVC
    }
}
