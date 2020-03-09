//
//  AttachmentPreviewViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 15/02/2020.
//  Copyright © 2020 grabss corporation.. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

// MARK: - AttachmentPreviewViewController
final class AttachmentPreviewViewController: ViewBase {

    // MARK: - Outlets

    @IBOutlet weak private var wkWebView: WKWebView!
    @IBOutlet weak private var labelUnpreviewable: UILabel!

    // MARK: - Variables

    private var presenter: AttachmentPreviewPresenterInterface {
        return presenterInterface as! AttachmentPreviewPresenterInterface
    }

    private var canDownload = true

    // MARK: - Overrides

    override func didTapRightBarButtonItem(_ index: Int) {
        presenter.didTapDownload()
    }

    func showLoading(message: String? = nil, _ needFullScreen: Bool = false, _ usingSafeArea: Bool = false) {
        super.showLoading(message: message, needFullScreen, usingSafeArea)
        rightBarButtonItems?.forEach({ item in
            item.isEnabled = false
        })
    }

    func hideLoading() {
        super.hideLoading()
        rightBarButtonItems?.forEach({ item in
            item.isEnabled = canDownload
        })
    }

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        wkWebView.navigationDelegate = self
    }
}

// MARK: - AttachmentPreviewViewInterface
extension AttachmentPreviewViewController: AttachmentPreviewViewInterface {

    func showPreview(_ url: URL, _ canDownload: Bool) {
        if previewableExtensions.contains(String(url.lastPathComponent.split(separator: ".").last!).lowercased()) {
            labelUnpreviewable.isHidden = true
            wkWebView.isHidden = false
            showLoading()
//            let request = APIRouter.generateHeaderAddedRequest(url.absoluteString)
//            wkWebView.load(request)
            Alamofire.request(APIRouter.generateHeaderAddedRequest(url.absoluteString)).response { [unowned self] res in
                self.wkWebView.load(res.data!, mimeType: String(url.lastPathComponent.split(separator: ".").last!).toMIMETypeFromExt()!, characterEncodingName: "UTF-8", baseURL: url)
            }
        } else {
            labelUnpreviewable.isHidden = false
            wkWebView.isHidden = true
        }
        self.canDownload = canDownload
        rightBarButtonItems?.forEach({ item in
            item.isEnabled = canDownload
        })
    }
}

// MARK: - WKNavigationDelegate
extension AttachmentPreviewViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideLoading()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideLoading()
        let code = (error as NSError).code
        if code == 102 || code == 204 {
             return
        }
        handleError(error, nil)
    }
}
