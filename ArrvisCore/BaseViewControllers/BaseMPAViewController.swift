//
//  BaseMPAViewController.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/06/17.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import WebKit
import TinyConstraints

/// MPA用ViewController基底クラス
open class BaseMPAViewController: BaseViewController {

    // MARK: - Variables

    /// PageのURL
    open var pageUrl: URL? {
        return nil
    }

    /// PageのHTML
    open var pageHtml: URL? {
        return nil
    }

    /// WebViewのインセット
    open var webViewInsets: UIEdgeInsets {
        return .zero
    }

    /// WebViewフェードイン時間
    open var webViewFadeInDuration: TimeInterval {
        return 0.2
    }

    /// WebViewフェードイン遅延時間
    open var webViewFadeInDelayDuration: TimeInterval {
        return 0.4
    }

    /// Viewからのコールバックマップ [コールバック名: コールバックAction]
    open var pageCallbacks: [String: (Data?) -> Void] {
        return [String: (Data?) -> Void]()
    }

    /// WebView
    public var webView: WKWebView?

    private let userContentController = WKUserContentController()

    // MARK: - Initializer

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let pageUrl = pageUrl {
            initWebView()
            webView!.load(URLRequest(url: pageUrl))
        }
    }

    // MARK: - Life-Cycke

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pageCallbacks.forEach { [unowned self] callBack in
            self.userContentController.add(self, name: callBack.key)
        }
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pageCallbacks.forEach { [unowned self] callBack in
            self.userContentController.removeScriptMessageHandler(forName: callBack.key)
        }
    }

    // MARK: - ExtendsViewControllerEventsHandleable

    open override func onDidFirstLayoutSubviews() {
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

    open func onWebViewError(_ error: Error, file: String = #file, function: String = #function) {}
}

// MARK: - Public
extension BaseMPAViewController {

    /// WebView初期化
    public func initWebView() {
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
        webView?.addedConstraints = webView?.edgesToSuperview(insets: webViewInsets)
    }
}

// MARK: - WKNavigationDelegate
extension BaseMPAViewController: WKNavigationDelegate {

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
        onWebViewError(error)
    }
}

// MARK: - WKScriptMessageHandler
extension BaseMPAViewController: WKScriptMessageHandler {

    public func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage) {
        let data = (message.body as? String)?.data(using: .utf8)
        onReceiveCallback(message.name, data)
        pageCallbacks[message.name]?(data)
    }
}

// MARK: - JS methods
extension BaseMPAViewController {

    /// JSメソッド呼び出し
    public func callJSMethod<T: BaseModel>(
        _ path: [String],
        _ body: T?,
        file: String = #file,
        function: String = #function) {
        executeJS("\(path.joined(separator: "."))(\(body?.toJsString() ?? ""))")
    }

    /// JS実行
    public func executeJS(_ jsString: String, file: String = #file, function: String = #function) {
        if webView?.isLoading == true {
            NSObject.runAfterDelay(delayMSec: 30) { [unowned self] in
                self.executeJS(jsString, file: file, function: function)
            }
            return
        }
        webView?.evaluateJavaScript(jsString, completionHandler: { [unowned self] (ret, error) in
            if let error = error {
                self.onWebViewError(error, file: file, function: function)
            } else {
                self.onExecuteJSCompleted(jsString, ret, file: file, function: function)
            }
        })
    }
}
