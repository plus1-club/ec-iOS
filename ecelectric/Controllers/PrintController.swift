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

extension PrintController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        iLoader.shared.hide()
    }
}
