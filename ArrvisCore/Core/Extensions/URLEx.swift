//
//  URLEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2020/02/07.
//  Copyright © 2020 Arrvis Co., Ltd. All rights reserved.
//

import Photos

extension URL {

    /// Thumbnail生成
    public func generateThumbnail() -> UIImage? {
        let imageGenerator = AVAssetImageGenerator(asset: AVAsset(url: self))
        imageGenerator.appliesPreferredTrackTransform = true
        do {
            let imageRef
                = try imageGenerator.copyCGImage(at: CMTimeMake(value: Int64(0), timescale: 1), actualTime: nil)
            let image = UIImage(cgImage: imageRef)
            return image
        } catch {
            return nil
        }
    }
}
