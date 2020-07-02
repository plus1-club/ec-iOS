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
import iLoader

class PrintController: UIViewController {

    var webView: WKWebView!
    var pdfFilePath: URL!
    var shareButton = UIButton()
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        let rectWeb = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 20)
        webView.frame = rectWeb
        view.addSubview(webView)
        
        shareButton = UIButton(type: .roundedRect)
        let rectBtn = CGRect(x: 0, y: view.frame.height - 20, width: view.frame.width, height: 20)
        shareButton.frame = rectBtn
        shareButton.setTitle("Поделиться", for: .normal)
        shareButton.addTarget(self, action: #selector(sharePDF(sender:)), for: .touchDown)
        view.addSubview(shareButton)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        iLoader.shared.show()
        let myRequest = URLRequest(url: pdfFilePath!)
        webView.load(myRequest)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        if webView.isLoading {
            return
        }
        savePdf()
    }
    
    func savePdf(){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            as NSString).appendingPathComponent("doc.pdf")
        let pdfDoc = NSData(contentsOf: pdfFilePath)
        fileManager.createFile(atPath: paths as String, contents: pdfDoc as Data?, attributes: nil)
    }
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    @objc func sharePDF(sender: UIButton){
        let fileManager = FileManager.default
        let docPath = (getDirectoryPath() as NSString).appendingPathComponent("doc.pdf")
        if fileManager.fileExists(atPath: docPath){
            let doc = NSData(contentsOfFile: docPath)
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [doc!], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            present(activityViewController, animated: true, completion: nil)
        } else {
            print("document not found")
        }
    }
}

extension PrintController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        iLoader.shared.hide()
    }
}
