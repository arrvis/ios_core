//
//  BaseVueViewController.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/06/17.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import WebKit
import TinyConstraints

/// Vue用ViewController基底クラス
open class BaseVueViewController: BaseViewController, DidFirstLayoutSubviewsHandleable {

    // MARK: - Variables

    /// PageのURLBase
    open var pageHtmlURLPrefix: String? {
        return nil
    }

    /// PageのHTML
    open var pageHtml: URL? {
        return nil
    }

    /// Viewからのコールバックマップ [コールバック名: コールバックAction]
    open var pageCallbacks: [String: (Data?) -> Void] {
        return [String: (Data?) -> Void]()
    }

    /// WebViewのインセット
    open var webViewInsets: UIEdgeInsets {
        return .zero
    }

    /// WebView
    public var webView: WKWebView?

    /// WebViewフェードイン時間
    open var webViewFadeInDuration: TimeInterval {
        return 0.2
    }

    /// WebViewフェードイン遅延時間
    open var webViewFadeInDelayDuration: TimeInterval {
        return 0.4
    }

    // MARK: - Initializer

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        if let pageHtml = pageHtml {
            initWebView()
            if let pageHtmlURLPrefix = pageHtmlURLPrefix {
                let url = URL(string: pageHtmlURLPrefix + String(pageHtml.absoluteString.split(separator: "/").last!))!
                webView!.load(URLRequest(url: url))
            } else {
                webView!.load(URLRequest(url: pageHtml))
            }
        }
    }

    // MARK: - DidFirstLayoutSubviewsHandleable

    open func onDidFirstLayoutSubviews() {
        if let webView = webView {
            view.addSubview(webView)
            view.bringSubviewToFront(webView)
            refreshWebViewInsets()
        }
    }

    // MARK: - Events

    open func onWebViewDidLoad() {}

    open func onExecuteJSCompleted(_ js: String, _ ret: Any?, file: String = #file, function: String = #function) {}

    open func onReceiveCallback(_ name: String, _ body: Data?) {}

    open func onWebViewError(_ js: String?, _ error: Error, function: String = #function) {}
}

// MARK: - Public
extension BaseVueViewController {

    /// WebView初期化
    public func initWebView() {
        let userContentController = WKUserContentController()
        pageCallbacks.forEach { callBack in
            userContentController.add(self, name: callBack.key)
        }
        let webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.userContentController = userContentController
        webView = WKWebView(
            frame: (UIApplication.shared.delegate!.window!?.rootViewController!.view!.frame)!,
            configuration: webViewConfiguration
        )
        webView!.backgroundColor = .clear
        webView!.isOpaque = false
        webView!.navigationDelegate = self
        webView!.scrollView.bounces = false
        webView!.alpha = 0
    }

    /// WebViewのInsetsを更新
    public func refreshWebViewInsets() {
        webView?.addedConstraints?.deActivate()
        webView?.addedConstraints?.removeAll()
        webView?.edgesToSuperview(insets: webViewInsets)
    }
}

// MARK: - WKNavigationDelegate
extension BaseVueViewController: WKNavigationDelegate {

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.setNeedsLayout()
        if let webView = self.webView {
            onWebViewDidLoad()
            UIView.animate(withDuration: webViewFadeInDuration, delay: webViewFadeInDelayDuration, animations: {
                webView.alpha = 1
            })
        }
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        onWebViewError(nil, error)
    }
}

// MARK: - WKScriptMessageHandler
extension BaseVueViewController: WKScriptMessageHandler {

    public func userContentController(_ userContentController: WKUserContentController,
                                      didReceive message: WKScriptMessage) {
        let data = (message.body as? String)?.data(using: .utf8)
        onReceiveCallback(message.name, data)
        pageCallbacks[message.name]?(data)
    }
}

// MARK: - Vue methods
extension BaseVueViewController {

    /// Vueメソッド呼び出し
    public func callVueMethod<T: BaseModel>(_ name: String, _ model: T,
                                            file: String = #file, function: String = #function) {
        callVueMethod(name, model.jsonString, file: file, function: function)
    }

    /// Vueメソッド呼び出し
    public func callVueMethod<T: BaseModel>(_ name: String, _ models: [T],
                                            file: String = #file, function: String = #function) {
        callVueMethod(name,
                      "[\(models.compactMap { $0.jsonString}.joined(separator: ","))]",
                      file: file, function: function)
    }

    /// Vueメソッド呼び出し
    public func callVueMethodWithObject(_ name: String, _ object: Any,
                                        file: String = #file, function: String = #function) {
        executeJS("window.vue.\(name)(\(object))", file: file, function: function)
    }

    /// Vueメソッド呼び出し
    public func callVueMethod(_ name: String, _ jsonString: String? = nil,
                              file: String = #file, function: String = #function) {
        if let data = jsonString?.data(using: .utf8)?.base64EncodedString() {
            executeJS("window.vue.\(name)('\(data)')", file: file, function: function)
        } else {
            executeJS("window.vue.\(name)()", file: file, function: function)
        }
    }

    private func executeJS(_ jsString: String, file: String = #file, function: String = #function) {
        if webView?.isLoading == true {
            NSObject.runAfterDelay(delayMSec: 30) { [unowned self] in
                self.executeJS(jsString, file: file, function: function)
            }
            return
        }
        webView?.evaluateJavaScript(jsString, completionHandler: { [unowned self] (ret, error) in
            if let error = error {
                self.onWebViewError(jsString, error, function: function)
            } else {
                self.onExecuteJSCompleted(jsString, ret, file: file, function: function)
            }
        })
    }
}
