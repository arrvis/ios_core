//
//  UIImageViewEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/16.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import UIKit

private var loadingImageUrlKey = 0
private var activeImageUrlKey = 1
private var loadedImageKey = 2

extension UIImageView {

    private var loadingImageUrl: String? {
        get {
            guard let object = objc_getAssociatedObject(self, &loadingImageUrlKey) as? String else {
                return nil
            }
            return object
        }
        set {
            objc_setAssociatedObject(self, &loadingImageUrlKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    private var activeImageUrl: String? {
        get {
            guard let object = objc_getAssociatedObject(self, &activeImageUrlKey) as? String else {
                return nil
            }
            return object
        }
        set {
            objc_setAssociatedObject(self, &activeImageUrlKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    private var loadedImage: String? {
        get {
            guard let object = objc_getAssociatedObject(self, &loadedImageKey) as? String else {
                return nil
            }
            return object
        }
        set {
            objc_setAssociatedObject(self, &loadedImageKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    /// 画像ロード インディケーター付き
    ///
    /// - Parameters:
    ///   - urlString: URL文字列
    ///   - color: インディケーター色
    ///   - completion: 完了
    public func loadImageAsyncWithIndicator(urlString: String,
                                            color: UIColor = .lightGray,
                                            completion: ((UIImage?) -> UIImage?)? = nil) {
        if activeImageUrl == urlString && image != nil && image?.base64DataString == loadedImage {
            return
        }
        if image != nil {
            image = nil
            activeImageUrl = nil
        }

        let indicatorView = UIActivityIndicatorView()
        indicatorView.color = color
        indicatorView.backgroundColor = .clear
        indicatorView.startAnimating()
        _ = addSubviewToCenter(indicatorView)

        loadingImageUrl = urlString
        UIImage.loadImageAsync(fromUrl: urlString) { [weak self] ret in
            indicatorView.stopAnimating()
            indicatorView.removeFromSuperview()
            if urlString == self?.loadingImageUrl {
                self?.loadingImageUrl = nil
                if let completion = completion {
                    self?.image = completion(ret)
                } else {
                    self?.image = ret
                }
                self?.activeImageUrl = urlString
                self?.loadedImage = self?.image?.base64DataString
            }
        }
    }

    /// 画像ロード インディケーター付き
    ///
    /// - Parameters:
    ///   - urlString: URL文字列
    ///   - completion: 完了
    public func loadImage(urlString: String) -> UIImage? {
        let image = UIImage.loadImage(fromUrl: urlString)
        activeImageUrl = urlString
        loadedImage = image?.base64DataString
        return image
    }
}
