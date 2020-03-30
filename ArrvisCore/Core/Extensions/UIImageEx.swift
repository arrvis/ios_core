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
    public func scaleTo(_ size: CGSize, _ ignoreScreenScale: Bool = false) -> UIImage {
        if ignoreScreenScale {
            return fixOrientation().af_imageScaled(
                to: CGSize(width: size.width / UIScreen.main.scale, height: size.width / UIScreen.main.scale)
            )
        }
        return fixOrientation().af_imageScaled(to: size)
    }

    /// サイズに合うようにScale
    public func scaleFillTo(_ size: CGSize, _ ignoreScreenScale: Bool = false) -> UIImage {
        if ignoreScreenScale {
            return fixOrientation().af_imageAspectScaled(
                toFill: CGSize(width: size.width / UIScreen.main.scale, height: size.width / UIScreen.main.scale)
            )
        }
        return fixOrientation().af_imageAspectScaled(toFill: size)
    }

    /// サイズに合うようにScale
    public func scaleFitTo(_ size: CGSize, _ ignoreScreenScale: Bool = false) -> UIImage {
        if ignoreScreenScale {
            return fixOrientation().af_imageAspectScaled(
                toFit: CGSize(width: size.width / UIScreen.main.scale, height: size.width / UIScreen.main.scale)
            )
        }
        return fixOrientation().af_imageAspectScaled(toFit: size)
    }

    /// 短い方の辺の長さに合わせて aspect ratioを維持してリサイズ
    ///
    /// - Parameters:
    ///   - minimumLength: リサイズ後の短い方の辺の長さ
    /// - Returns: リサイズ後Image
    public func resizeFill(minimumLength: CGFloat, _ ignoreScreenScale: Bool = false) -> UIImage {
        let resizedWidth: CGFloat
        let resizedHeight: CGFloat
        if self.size.width < self.size.height {
            resizedWidth = minimumLength
            resizedHeight = self.size.height * minimumLength / self.size.width
        } else {
            resizedWidth = self.size.width * minimumLength / self.size.height
            resizedHeight = minimumLength
        }
        return af_imageScaled(to: CGSize(
            width: resizedWidth / (ignoreScreenScale ? 1 : UIScreen.main.scale),
            height: resizedHeight / (ignoreScreenScale ? 1 : UIScreen.main.scale)
        ))
    }

    /// 長い方の辺の長さに合わせて aspect ratioを維持してリサイズ
    ///
    /// - Parameters:
    ///   - maximumLength: リサイズ後の長い方の辺の長さ
    /// - Returns: リサイズ後Image
    public func resizeFit(maximumLength: CGFloat, _ ignoreScreenScale: Bool = true) -> UIImage {
        let resizedWidth: CGFloat
        let resizedHeight: CGFloat
        if self.size.width < self.size.height {
            resizedWidth = self.size.width * maximumLength / self.size.height
            resizedHeight = maximumLength
        } else {
            resizedWidth = maximumLength
            resizedHeight = self.size.height * maximumLength / self.size.width
        }
        return af_imageScaled(to: CGSize(
            width: resizedWidth / (ignoreScreenScale ? 1 : UIScreen.main.scale),
            height: resizedHeight / (ignoreScreenScale ? 1 : UIScreen.main.scale)
        ))
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
        if let cgImage = fixOrientation().cgImage {
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

    /// 画像の向き修正
    public func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        var transform = CGAffineTransform.identity
        let width = size.width
        let height = size.height

        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: width, y: height)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: height)
            transform = transform.rotated(by: CGFloat(-Double.pi / 2))
        default:
            break
        }
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        let ctx = CGContext(
            data: nil,
            width: Int(UInt(width)),
            height: Int(UInt(height)),
            bitsPerComponent: cgImage!.bitsPerComponent,
            bytesPerRow: 0,
            space: cgImage!.colorSpace!,
            bitmapInfo: cgImage!.bitmapInfo.rawValue
        )
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx!.draw(cgImage!, in: CGRect(x: 0, y: 0, width: height, height: width))
        default:
            ctx!.draw(cgImage!, in: CGRect(x: 0, y: 0, width: width, height: height))
        }
        return UIImage(cgImage: ctx!.makeImage()!)
    }
}
