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
open class BaseVueViewController: BaseViewController {

    // MARK: - Variables

    /// MPAのURL
    var mpaBaseURL: String? {
        return nil
    }

    /// ViewのURL
    var viewUrl: URL? {
        return nil
    }

    /// Viewからのコールバックマップ [コールバック名: コールバックAction]
    var viewCallbacks: [String: (Data) -> Void] {
        return [String: (Data) -> Void]()
    }

    /// WebViewのインセット
    var webViewInsets: UIEdgeInsets {
        return .zero
    }

    /// WebView
    var webView: WKWebView?

    /// WebViewフェードイン時間
    var webViewFadeInDuration: TimeInterval {
        return 0.2
    }

    /// WebViewフェードイン遅延時間
    var webViewFadeInDelayDuration: TimeInterval {
        return 0.4
    }

    // MARK: - Initializer

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        if let viewUrl = viewUrl {
            initWebView()
            if let mpaBaseURL = mpaBaseURL {
                let url = URL(string: mpaBaseURL + String(viewUrl.absoluteString.split(separator: "/").last!))!
                webView!.load(URLRequest(url: url))
            } else {
                webView!.load(URLRequest(url: viewUrl))
            }
        }
    }

    func initWebView() {
        let userContentController = WKUserContentController()
        viewCallbacks.forEach { callBack in
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

    // MARK: - Override methods

    open override func onDidFirstLayoutSubviews() {
        if let webView = webView {
            view.addSubviewWithFit(webView, usingSafeArea: true)
            view.bringSubviewToFront(webView)
        }
    }

    // MARK: - public

    /// WebViewのInsetsを更新
    func refreshWebViewInsets() {
        webView?.addedConstraints?.deActivate()
        webView?.addedConstraints?.removeAll()
        webView?.edgesToSuperview(insets: webViewInsets)
    }}

// MARK: - Events
extension BaseVueViewController {

    open func onWebViewDidLoad() {}
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
}

// MARK: - WKScriptMessageHandler
extension BaseVueViewController: WKScriptMessageHandler {

    public func userContentController(_ userContentController: WKUserContentController,
                                      didReceive message: WKScriptMessage) {
        viewCallbacks[message.name]!((message.body as! String).data(using: .utf8)!)
    }
}

// MARK: - Vue methods
extension BaseVueViewController {

    /// Vueメソッド呼び出し
    func callVueMethod(name: String, _ jsonString: String?, _ completion: @escaping (Any?, Error?) -> Void) {
        if let jsonString = jsonString, let data = jsonString.data(using: .utf8)?.base64EncodedString() {
            executeJS("window.vue.\(name)('\(data)')", completion)
        } else {
            callVueMethod(name: name, completion)
        }
    }

    /// Vueメソッド呼び出し
    func callVueMethod<T: BaseModel>(name: String, _ model: T, _ completion: @escaping (Any?, Error?) -> Void) {
        let param: String
        if let jsonString = model.jsonString {
            let data = jsonString.data(using: .utf8)?.base64EncodedString() ?? ""
            param = "'\(data)'"
        } else {
            param = ""
        }
        executeJS("window.vue.\(name)(\(param))", completion)
    }

    /// Vueメソッド呼び出し
    func callVueMethod<T: BaseModel>(name: String, _ models: [T], _ completion: @escaping (Any?, Error?) -> Void) {
        let jsonString = "[\(models.compactMap { $0.jsonString}.joined(separator: ","))]"
        let param = "'\(jsonString.data(using: .utf8)?.base64EncodedString() ?? "")'"
        executeJS("window.vue.\(name)(\(param))", completion)
    }

    /// Vueメソッド呼び出し
    ///
    /// - Parameters:
    ///   - name: メソッド名
    ///   - completion: 完了アクション
    func callVueMethod(name: String, _ completion: @escaping (Any?, Error?) -> Void) {
        executeJS("window.vue.\(name)()", completion)
    }

    private func executeJS(_ jsString: String, _ completion: @escaping (Any?, Error?) -> Void) {
        if webView?.isLoading == true {
            NSObject.runAfterDelay(delayMSec: 30) { [unowned self] in
                self.executeJS(jsString, completion)
            }
            return
        }
        webView?.evaluateJavaScript(jsString, completionHandler: completion)
    }
}
