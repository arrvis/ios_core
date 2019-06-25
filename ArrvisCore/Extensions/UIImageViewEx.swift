//
//  UIImageViewEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/16.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

extension UIImageView {

    /// 画像ロード インディケーター付き
    ///
    /// - Parameters:
    ///   - urlString: URL文字列
    ///   - color: インディケーター色
    ///   - completion: 完了
    public func loadImageAsyncWithIndicator(urlString: String,
                                            color: UIColor = .lightGray,
                                            placeholderImage: UIImage? = nil,
                                            filter: ImageFilter? = nil,
                                            progress: AlamofireImage.ImageDownloader.ProgressHandler? = nil,
                                            progressQueue: DispatchQueue = DispatchQueue.main,
                                            imageTransition: UIImageView.ImageTransition = .noTransition,
                                            runImageTransitionIfCached: Bool = false,
                                            completion: ((Alamofire.DataResponse<UIImage>) -> Void)? = nil) {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.color = color
        indicatorView.backgroundColor = .clear
        indicatorView.startAnimating()
        _ = addSubviewToCenter(indicatorView)
        af_setImage(withURL: URL(string: urlString)!,
                    placeholderImage: placeholderImage,
                    filter: filter,
                    progress: progress,
                    progressQueue: progressQueue,
                    imageTransition: imageTransition,
                    runImageTransitionIfCached: runImageTransitionIfCached,
                    completion: completion)
    }
}
