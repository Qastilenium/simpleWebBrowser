//
//  ViewController.swift
//  simpleWebBrowser
//
//  Created by Ilryc Marokonen on 24.02.2024.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var progressView: UIProgressView!
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Browse", style: .plain, target: self, action: #selector(browseTapped))
        // MARK: - Progress bar
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        
        let progressButton = UIBarButtonItem(customView: progressView)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        toolbarItems = [progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = true
        
        
        // MARK: - URL load
        let url = URL(string: "https://google.com")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
      
    }

    
    // MARK: - Funcs
    @objc func browseTapped() {
        let alertController = UIAlertController(title: "Do you want to...", message: nil, preferredStyle: .alert)

        let browseAction = UIAlertAction(title: "Enter a site address", style: .default) { action in
            let textField = alertController.textFields?.first
            if let siteAddress = textField?.text {
                self.openPage(siteAddress)
            }
        }
        alertController.addTextField { _ in }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        
        alertController.addAction(browseAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func openPage(_ siteAddress: String?) {
        let url = URL(string: "https://" + siteAddress!)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
}

