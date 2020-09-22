//
//  PrintController.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 03/12/19.
//  Updated by Sergey Lavrov on 02/04/2020.
//  Copyright © 2019-2020 Samir Azizov & Sergey Lavrov. All rights reserved.
//

import UIKit
import WebKit

class PrintController: UIViewController {

    // MARK: - Variable
    var webView: WKWebView!
    var pdfFilePath: URL!
    var number: String!
    var isSaved = false
    
    // MARK: - Override
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        view = webView
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self,
                                          action: #selector(saveAndSharePDF(sender:)))
        navigationItem.rightBarButtonItem = shareButton
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingOverlay.shared.showOverlay(view: self.view)
        let myRequest = URLRequest(url: pdfFilePath!)
        webView.load(myRequest)
        savePdf()
    }

    // MARK: - Selector
    @objc func saveAndSharePDF(sender: UIButton){
        let group = DispatchGroup()
        
        group.enter()
        DispatchQueue.global(qos: .default).sync {
            if (!self.isSaved) {
                self.savePdf()
            }
            group.leave()
        }
        group.enter()
        DispatchQueue.global(qos: .default).sync {
            self.sharePdf()
            group.leave()
        }
        group.wait()
    }
    
    // MARK: - Method
    func savePdf(){
        let fileManager = FileManager.default
        let docPath = (getDirectoryPath() as NSString).appendingPathComponent(number+".pdf")
        let docData = NSData(contentsOf: pdfFilePath)
        print("Save: " + docPath)
        fileManager.createFile(atPath: docPath as String, contents: docData as Data?, attributes: nil)
        if fileManager.fileExists(atPath: docPath){
            isSaved = true
        }
    }
    
    func sharePdf(){
        let fileManager = FileManager.default
        let docPath = (self.getDirectoryPath() as NSString).appendingPathComponent(self.number+".pdf")
        print("Load: " + docPath)
        if fileManager.fileExists(atPath: docPath){
            let doc = NSData(contentsOfFile: docPath)
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [self.number+".pdf", doc!], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        } else {
            print("Document not found")
        }
    }

    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}

// MARK: -
extension PrintController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        LoadingOverlay.shared.hideOverlayView()
    }
}
