//
//  UIImageEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/16.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import UIKit

extension UIImage {

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
