//
//  RequestFromExcelCheckController.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 29/11/19.
//  Refactored by Sergey Lavrov on 02/07/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import UIKit
import MobileCoreServices

class RequestFromExcelCheckController: UIViewController, UIDocumentPickerDelegate {

    @available(iOS 11.0, *)
    private func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAs urls: [URL]){
        print("== Urls : \(urls)")
        guard let myUrl = urls.first else {
            return
        }
        let shouldStopAccessing = myUrl.startAccessingSecurityScopedResource()
        defer {
            if shouldStopAccessing {
                myUrl.stopAccessingSecurityScopedResource()
            }
        }
        print("== URL:",myUrl)
        print("== URL adress:", myUrl.absoluteString)
        self.file.text = myUrl.absoluteString
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController){
        print("== Close file dialog ==")
        dismiss(animated: true, completion: nil)
    }
    
    @available(iOS, introduced: 8.0, deprecated: 11.0)
    private func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAs url: URL){
        print("== URL:",url)
        print("== URL adress:", url.absoluteString)
        self.file.text = url.absoluteString
    }
    
    
    
    
    
    // MARK: - Outlet
    @IBOutlet weak var file: UITextField!
    @IBOutlet weak var productColumn: UITextField!
    @IBOutlet weak var countColumn: UITextField!
    @IBOutlet weak var fullsearch: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!

    let document = UIDocumentInteractionController()
    var fileDialog = UIDocumentPickerViewController(documentTypes: [
        kUTTypePDF as String,
        "com.microsoft.excel.xls",
        "org.openxmlformats.spreadsheetml.sheet"
    ] as [String], in: .open)

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        document.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Action
    @IBAction func checkTapped(_ sender: Button) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "SearchController") as! SearchController
        self.navigationController?.pushViewController(controller, animated: true)
     }
    
    @IBAction func selectFile(_ sender: UIButton) {        
        if #available(iOS 11.0, *){
            fileDialog.allowsMultipleSelection = false
        }
        if #available(iOS 13.0, *){
            fileDialog.shouldShowFileExtensions = true
        }
        fileDialog.delegate = self
        fileDialog.modalPresentationStyle = .formSheet
        self.present(fileDialog, animated: true,
             completion:{
                print("== File Dialog open ==")
        })
    }
    
    @IBAction func downloadExample(_ sender: UIButton) {
        Basket().downloadExample(successBlock: { (fileURL) in
            self.storeAndShare(url: fileURL)
        }) { (error) in
            Utilities.alertMessage(parent: self, message: error)
        }
    }
}

// MARK: -
extension RequestFromExcelCheckController {
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
extension RequestFromExcelCheckController: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let navVC = self.navigationController else {
            return self
        }
        return navVC
    }
}
