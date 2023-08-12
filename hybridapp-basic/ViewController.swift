//
//  ViewController.swift
//  hybridapp-basic
//
//  Created by Sarah Jeong on 2023/07/29.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate {

    @IBOutlet var webView: WKWebView!
    var popupView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let monitor = checkNetwork.shared
        print("Network status: \(monitor)")
        
        webView.uiDelegate = self
        webviewInit()

    }

    func webviewInit() {
        
        // 1. Create WKWebViewConfiguration instance
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        
        // 2. WKWebview setting
        webView.configuration.allowsInlineMediaPlayback = true
        webView.configuration.mediaTypesRequiringUserActionForPlayback = []
        
        // 4. Load web content into the web view
        // https://m.officecheckin.com
        if let url = URL(string: "https://m.officecheckin.com") {
            let request = URLRequest(url: url)
            webView.load(request)
            
        }
        
        // For safari Debuggin
        if #available(iOS 16, *) {
            webView.isInspectable = true
        }
        
        webView.allowsBackForwardNavigationGestures = true
        
        // 5. Remove website data
        WKWebsiteDataStore.default().removeData(ofTypes: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache], modifiedSince: Date(timeIntervalSince1970: 0)) {
        }
    }
}

extension ViewController {
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        popupView = WKWebView(frame: UIScreen.main.bounds, configuration: configuration)
        popupView?.autoresizingMask = [.flexibleWidth, .flexibleWidth]
        popupView?.uiDelegate = self
        
        view.addSubview(popupView!)
        
        return popupView
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        if webView == popupView {
            popupView?.removeFromSuperview()
            popupView = nil
        }
    }
}
