//
//  WebVC.swift
//  lashojas
//
//  Created by Robin Hare on 2/15/21.
//

import UIKit
import WebKit
import SnapKit

class WebVC: BaseVC {
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var nabArea: UIView!
    
    @IBAction func onMenu(_ sender: Any) {
        self.openMenu()
    }
    
    var titleStr: String = ""
    var urlStr: String = ""
    var jscript: String = ""

    var webView: WKWebView!
    
    var bottomSafeArea: CGFloat {
        get {
            let window = UIApplication.shared.windows[0]
            let topPadding = window.safeAreaInsets.top
            return window.safeAreaInsets.bottom
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbl_title.text = titleStr
        
        if let url = URL(string: urlStr) {
            let request = URLRequest(url: url)
            
            jscript = """
                var meta = document.createElement('meta');
                meta.setAttribute('name', 'viewport');
                meta.setAttribute('content', 'width=device-width');
                meta.setAttribute('shrink-to-fit', 'YES');
                document.getElementsByTagName('head')[0].appendChild(meta);
            """
            let userScript = WKUserScript(source: jscript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            let wkUController = WKUserContentController()
            wkUController.addUserScript(userScript)
            let wkWebConfig = WKWebViewConfiguration()
            wkWebConfig.userContentController = wkUController
            
            let webView = WKWebView(frame: CGRect.zero, configuration: wkWebConfig) // yourwebview is the webview that you are using.
            webView.uiDelegate = self
            webView.navigationDelegate = self
            
            view.addSubview(webView)
            webView.translatesAutoresizingMaskIntoConstraints = false
            view.addConstraint(NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal, toItem: nabArea, attribute: .bottom, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: webView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: webView, attribute: .right, relatedBy: .equal, toItem: view , attribute: .right, multiplier: 1, constant:0))
            view.addConstraint(NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem:view, attribute: .bottom, multiplier: 1, constant: bottomSafeArea))
            view.layoutIfNeeded()
            
            webView.scrollView.bounces = true
            webView.autoresizingMask = ([.flexibleHeight, .flexibleWidth])
            
            webView.load(request)
        }
    }
}

extension WebVC: WKUIDelegate, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        webView.evaluateJavaScript(jscript)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        if navigationAction.navigationType == WKNavigationType.linkActivated {
            print("here link Activated!!!")
            if let url = navigationAction.request.url {
                if !url.absoluteString.contains("lashojasresort.club") {
                    let shared = UIApplication.shared
                    if shared.canOpenURL(url) {
                        shared.open(url, options: [:], completionHandler: nil)
                    }
                    decisionHandler(.cancel)
                } else {
                    decisionHandler(.allow)
                }
            } else {
                decisionHandler(.allow)
            }
        }
        else {
            decisionHandler(.allow)
        }
    }
}
