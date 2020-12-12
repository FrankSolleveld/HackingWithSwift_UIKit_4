//
//  ViewController.swift
//  Project4
//
//  Created by Frank Solleveld on 12/12/2020.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    // MARK: -- Custom Variables
    var webView: WKWebView!
    
    // MARK: -- Lifecycle Methods
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://devfrank.org")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }


}

