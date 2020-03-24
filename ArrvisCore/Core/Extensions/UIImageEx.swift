//
//  UIImageEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/16.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import AlamofireImage

extension UIImage {

    private static let imageDownloader = ImageDownloader()

    /// Base64データ文字列
    public var base64DataString: String? {
        guard let pngData = pngData() as NSData? else {
            return nil
        }
        return "data:image/png;base64,\(pngData.base64EncodedString(options: []))"
    }

    /// Base64データ文字列から復元
    public static func devodeFromBase64DataString(_ string: String) -> UIImage? {
        return UIImage(data: Data(base64Encoded: string)!)
    }

    /// 画像ロード
    public static func loadImage(
        _ urlString: String,
        filter: ImageFilter? = nil,
        completion: @escaping (UIImage?) -> Void) {
        imageDownloader.download(URLRequest(url: URL(string: urlString)!), filter: filter) { response in
            completion(response.result.value)
        }
    }

    /// サイズに合うようにScale
    public func scaleTo(_ size: CGSize) -> UIImage {
        return af_imageScaled(to: size)
    }

    /// サイズに合うようにScale
    public func scaleFillTo(_ size: CGSize) -> UIImage {
        return af_imageAspectScaled(toFill: size)
    }

    /// サイズに合うようにScale
    public func scaleFitTo(_ size: CGSize) -> UIImage {
        return af_imageAspectScaled(toFit: size)
    }

    /// 短い方の辺の長さに合わせて aspect ratioを維持してリサイズ
    ///
    /// - Parameters:
    ///   - minimumLength: リサイズ後の短い方の辺の長さ
    /// - Returns: リサイズ後Image
    public func resizeFit(minimumLength: CGFloat) -> UIImage {
        if self.size.width < self.size.height {
            let resizedHeight = self.size.height * minimumLength / self.size.width
            return af_imageScaled(to: CGSize(width: minimumLength, height: resizedHeight))
        } else {
            let resizedWidth = self.size.width * minimumLength / self.size.height
            return af_imageScaled(to: CGSize(width: resizedWidth, height: minimumLength))
        }
    }

    /// 長い方の辺の長さに合わせて aspect ratioを維持してリサイズ
    ///
    /// - Parameters:
    ///   - maximumLength: リサイズ後の長い方の辺の長さ
    /// - Returns: リサイズ後Image
    public func resizeFill(maximumLength: CGFloat) -> UIImage {
        if self.size.width < self.size.height {
            let resizedWidth = self.size.width * maximumLength / self.size.height
            return af_imageScaled(to: CGSize(width: resizedWidth, height: maximumLength))
        } else {
            let resizedHeight = self.size.height * maximumLength / self.size.width
            return af_imageScaled(to: CGSize(width: maximumLength, height: resizedHeight))
        }
    }

    /// 丸める
    public func round() -> UIImage {
        return af_imageRoundedIntoCircle()
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
