//
//  ViewController.swift
//  hybridapp-basic
//
//  Created by Sarah Jeong on 2023/07/29.
//

import UIKit
import WebKit
import SystemConfiguration
import Network

class ViewController: UIViewController, WKUIDelegate {

    @IBOutlet var webView: WKWebView!
    var popupView: WKWebView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let monitor = checkNetwork.shared
        print("Network status: \(monitor.isConnected ? "Connected via \(monitor.connectionType)" : "Not Connected")")
        
        webView.uiDelegate = self
        webviewInit()
    }


    func webviewInit() {
        
        // 1. Create WKWebViewConfiguration instance
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        
        // For safari Debuggin
        if #available(iOS 16, *) {
            webView.isInspectable = true
        }

        // 2. WKWebview setting
        webView = WKWebView(frame: webView.frame, configuration: webConfiguration)
        view.addSubview(webView)

        // 3. Set User-Agent
        // 4. Load web content into the web view
        if let url = URL(string: "https://m.officecheckin.com") {
            var request = URLRequest(url: url)
            
            if let userAgent = webView.value(forKey: "userAgent") as? String {
                webView.customUserAgent = userAgent
                print("User-Agent: \(userAgent)")
            } else {
                var customUserAgent = "Custom User-Agent"
                webView.customUserAgent = customUserAgent
                print("Custom User-Agentt: \(customUserAgent)")
            }
    
            webView.load(request)
        }
        
        webView.allowsBackForwardNavigationGestures = true
        
        // 5. Remove website data
        WKWebsiteDataStore.default().removeData(ofTypes: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache], modifiedSince: Date(timeIntervalSince1970: 0)) {
        }
    }
}

// popup view managetment
extension ViewController {
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if popupView == nil {
            popupView = WKWebView(frame: UIScreen.main.bounds, configuration: configuration)
            popupView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            popupView?.uiDelegate = self
        }
        
        // If the popup view is not already added to the view hierarchy, add it.
        if popupView?.superview == nil {
            view.addSubview(popupView!)
        }
    
        return popupView
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        if webView == popupView {
            popupView?.removeFromSuperview()
            popupView = nil
        }
    }
}
