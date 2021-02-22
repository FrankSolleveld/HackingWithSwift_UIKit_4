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
    var progressView: UIProgressView!
    var selectedWebsite: String = ""
    var websites = [String]()
    
    // MARK: -- Lifecycle Methods
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBarItems()
        let url = URL(string: "https:" + selectedWebsite)!
        checkForWhitelist(site: selectedWebsite)
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }

    // MARK: -- Custom Methods
    func setupBarItems(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let goBack = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),style: .plain, target: webView, action: #selector(webView.goBack))
        let goForward = UIBarButtonItem(image: UIImage(systemName: "chevron.forward"),style: .plain, target: webView, action: #selector(webView.goForward))
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        toolbarItems = [goBack, goForward, progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open Page...", message: nil, preferredStyle: .actionSheet)
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction){
        guard let title = action.title else { return }
        guard let url = URL(string: "https://" + title) else { return }
        selectedWebsite = title
        checkForWhitelist(site: selectedWebsite)
        webView.load(URLRequest(url: url))
    }
    
    func checkForWhitelist(site: String){
        if site != selectedWebsite {
            // Alert saying the website is not whitelisted.
            let ac = UIAlertController(title: "Website not permitted", message: "This website is not whitelisted.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Got it", style: .default))
            present(ac, animated: true)
        }
    }

    // MARK: -- Delegate Methods
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
   
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "estimatedProgress" {
                progressView.progress = Float(webView.estimatedProgress)
            }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        if let host = url?.host {
            for website in websites {
                if host.contains(website){
                    decisionHandler(.allow)
                    return
                }
            }
        }
        decisionHandler(.cancel)
    }
}
