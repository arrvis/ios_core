//
//  UIImageEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/16.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

extension UIImage {

    /// Base64データ文字列
    public var base64DataString: String? {
        guard let pngData = self.pngData() as NSData? else {
            return nil
        }
        return "data:image/png;base64,\(pngData.base64EncodedString(options: []))"
    }

    /// 画像を同期ロード
    ///
    /// - Parameter url: URL文字列
    /// - Returns: 画像
    public static func loadImage(fromUrl url: String) -> UIImage? {
        if url.isEmpty {
            return nil
        }
        var processing = true
        var responseImage: UIImage?
        Alamofire.request(url).responseImage { response in
            responseImage = response.result.value
            processing = false
        }

        let runLoop = RunLoop.current
        while processing && runLoop.run(mode: RunLoop.Mode.default, before: NSDate(timeIntervalSinceNow: 0.1) as Date) {
        }
        return responseImage
    }

    /// 画像を非同期ロード
    ///
    /// - Parameters:
    ///   - url: URL文字列
    ///   - completion: 完了
    public static func loadImageAsync(fromUrl url: String, completion: @escaping (UIImage?) -> Void) {
        if url.isEmpty {
            completion(nil)
            return
        }
        Alamofire.request(url).responseImage(queue: DispatchQueue.global(qos: .userInitiated)) { response in
            runOnMainThread {
                completion(response.result.value)
            }
        }
    }

    /// 画像を非同期ロード
    ///
    /// - Parameters:
    ///   - url: URL文字列
    ///   - completion: 完了
    public static func loadImageAsync(fromUrl url: String,
                                      width: CGFloat,
                                      height: CGFloat,
                                      completion: @escaping (UIImage?) -> Void) {
        loadImageAsync(fromUrl: url) { image in
            guard let resizedImage = image?.resize(width: width, height: height) else {
                return
            }
            completion(resizedImage)
        }
    }

    /// 画像を非同期ロード
    ///
    /// - Parameters:
    ///   - url: URL文字列
    ///   - completion: 完了
    public static func loadImageAsync(fromUrl url: String,
                                      minimumLength: CGFloat,
                                      completion: @escaping (UIImage?) -> Void) {
        loadImageAsync(fromUrl: url) { image in
            guard let resizedImage = image?.resizeFit(minimumLength: minimumLength) else {
                return
            }
            completion(resizedImage)
        }
    }

    /// サイズに合うようにScale
    ///
    /// - Parameter size: サイズ
    /// - Returns: Scale後Image
    public func scaleTo(size: CGSize) -> UIImage? {
        let widthRatio = size.width == 0 ? 1 : size.width / self.size.width
        let heightRatio = size.height == 0 ? 1 : size.height / self.size.height
        let scale = (widthRatio < heightRatio) ? widthRatio : heightRatio
        return scaleTo(scale: scale)
    }

    /// サイズに合うようにScale
    ///
    /// - Parameter size: サイズ
    /// - Returns: Scale後Image
    public func scaleFillTo(size: CGSize) -> UIImage? {
        let widthRatio = size.width == 0 ? 1 : size.width / self.size.width
        let heightRatio = size.height == 0 ? 1 : size.height / self.size.height
        let scale = (widthRatio < heightRatio) ? heightRatio : widthRatio
        return scaleTo(scale: scale)
    }

    private func scaleTo(scale: CGFloat) -> UIImage? {
        return resize(width: (size.width * scale), height: (size.height * scale))
    }

    /// リサイズ aspectRatio無視
    ///
    /// - Parameters:
    ///   - width: 幅
    ///   - height: 高さ
    /// - Returns: リサイズ後Image
    public func resize(width: CGFloat, height: CGFloat) -> UIImage! {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0.0)
        draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage?.withRenderingMode(.automatic)
    }

    /// 短い方の辺の長さに合わせて aspect ratioを維持してリサイズ
    ///
    /// - Parameters:
    ///   - minimumLength: リサイズ後の短い方の辺の長さ
    /// - Returns: リサイズ後Image
    public func resizeFit(minimumLength: CGFloat) -> UIImage! {
        if self.size.width < self.size.height {
            let resizedHeight = self.size.height * minimumLength / self.size.width
            return resize(width: minimumLength, height: resizedHeight)
        } else {
            let resizedWidth = self.size.width * minimumLength / self.size.height
            return resize(width: resizedWidth, height: minimumLength)
        }
    }

    /// 切り抜く
    ///
    /// - Parameter rect: Rect
    /// - Returns: 切り抜き後Image
    public func crop(rect: CGRect) -> UIImage? {
        var opaque = false
        if let cgImage = cgImage {
            switch cgImage.alphaInfo {
            case .noneSkipLast, .noneSkipFirst:
                opaque = true
            default:
                break
            }
        }

        UIGraphicsBeginImageContextWithOptions(rect.size, opaque, scale)
        draw(at: CGPoint(x: -rect.origin.x, y: -rect.origin.y))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }

    /// 画像の向き OrientationUp変更
    ///
    /// - Parameter
    /// - Returns: OrientationUpImage
    public func rotateOrientationUp() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        let ctx = CGContext(data: nil,
                            width: Int(self.size.width),
                            height: Int(self.size.height),
                            bitsPerComponent: (self.cgImage)!.bitsPerComponent,
                            bytesPerRow: 0, space: (self.cgImage)!.colorSpace!,
                            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        ctx.concatenate(orientationUpTransform())

        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.height, height: self.size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        }

        let cgimg = ctx.makeImage()!
        let img = UIImage(cgImage: cgimg)

        return img
    }

    private func orientationUpTransform() -> CGAffineTransform {
        var transform = CGAffineTransform.identity
        // rotate
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi / 2))
        case .up, .upMirrored: break
        @unknown default:
            break
        }
        // scale
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right: break
        @unknown default:
            break
        }
        return transform
    }
}
