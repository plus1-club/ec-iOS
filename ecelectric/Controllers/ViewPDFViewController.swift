//
//  ViewPDFViewController.swift
//  EC-online
//
//  Created by Dhaval Dobariya on 03/12/19.
//  Copyright © 2019 Samir Azizov. All rights reserved.
//

import UIKit
import WebKit
import iLoader

class ViewPDFViewController: UIViewController {

    var webView: WKWebView!
    var pdfFilePath: URL!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        iLoader.shared.show()

        let myRequest = URLRequest(url: pdfFilePath!)
        webView.load(myRequest)

    }
    

    
}

extension ViewPDFViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        iLoader.shared.hide()
    }
}
