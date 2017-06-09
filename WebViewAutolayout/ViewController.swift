//
//  ViewController.swift
//  WebViewAutolayout
//
//  Created by Jörn Schoppe on 09.06.17.
//  Copyright © 2017 pixeldock. All rights reserved.
//

import UIKit

var MyObservationContext = 0

class ViewController: UIViewController {

    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var webviewHeightConstraint: NSLayoutConstraint!
    
    var observing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webview.scrollView.isScrollEnabled = false
        webview.delegate = self
        if let url = URL(string: "https://www.google.de/intl/de/policies/terms/regional.html") {
            webview.loadRequest(URLRequest(url: url))
        }
    }
    
    deinit {
        stopObservingHeight()
    }
    
    func startObservingHeight() {
        let options = NSKeyValueObservingOptions([.new])
        webview.scrollView.addObserver(self, forKeyPath: "contentSize", options: options, context: &MyObservationContext)
        observing = true;
    }
    
    func stopObservingHeight() {
        webview.scrollView.removeObserver(self, forKeyPath: "contentSize", context: &MyObservationContext)
        observing = false
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else {
            super.observeValue(forKeyPath: nil, of: object, change: change, context: context)
            return
        }
        switch keyPath {
        case "contentSize":
            if context == &MyObservationContext {
                webviewHeightConstraint.constant = webview.scrollView.contentSize.height
            }
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

extension ViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webviewHeightConstraint.constant = webview.scrollView.contentSize.height
        if (!observing) {
            startObservingHeight()
        }
    }
}
