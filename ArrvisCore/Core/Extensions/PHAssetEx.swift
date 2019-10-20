//
//  PHAssetEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/03/31.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import Photos

extension PHAsset {

    /// URL取得
    public func getURL(completionHandler: @escaping ((_ responseURL: URL?) -> Void)) {
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(
                with: options,
                completionHandler: { (contentEditingInput: PHContentEditingInput?, _: [AnyHashable: Any]) -> Void in
                    completionHandler(contentEditingInput!.fullSizeImageURL as URL?)
                }
            )
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(
                forVideo: self,
                options: options,
                resultHandler: { (asset: AVAsset?, _: AVAudioMix?, _: [AnyHashable: Any]?) -> Void in
                    if let urlAsset = asset as? AVURLAsset {
                        let localVideoUrl: URL = urlAsset.url as URL
                        completionHandler(localVideoUrl)
                    } else {
                        completionHandler(nil)
                    }
                }
            )
        }
    }
}
