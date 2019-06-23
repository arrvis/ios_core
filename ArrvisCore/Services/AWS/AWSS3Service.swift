//
//  AWSS3Service.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/06/23.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

import UIKit
import Photos
import RxSwift
import AWSCore
import AWSS3
import Alamofire

/// S3へのアップロード設定
public struct S3UploadConfig {

    /// バケット名
    public let bucket: String

    /// アップロード先パス
    public let uploadPath: String

    /// 進捗コールバック
    public let progressBlock: ((Progress) -> Void)?

    func generateUploadKey(_ fileName: String) -> String {
        return "\(uploadPath)/\(fileName)"
    }
}

/// S3サービス
public final class AWSS3Service {

    // MARK: - Variables

    /// DisposeBag
    public static let disposeBag = DisposeBag()

    // MARK: - Initialize

    /// 初期化
    public static func initialize() {
        // AlamofireImageでS3にある画像にアクセスするのに必要
        Alamofire.DataRequest.addAcceptableImageContentTypes(["binary/octet-stream"])
    }

    // MARK: - General

    /// handleEventsForBackgroundURLSession
    public static func application(_ application: UIApplication,
                                   handleEventsForBackgroundURLSession identifier: String,
                                   completionHandler: @escaping () -> Void) {
        AWSS3TransferUtility.interceptApplication(application,
                                                  handleEventsForBackgroundURLSession: identifier,
                                                  completionHandler: completionHandler)
    }
}

// MARK: - Upload
extension AWSS3Service {

    /// PNGアップロード
    public static func uploadPNG(_ config: S3UploadConfig,
                                 _ image: UIImage,
                                 _ outputFileNameWithoutExt: String) -> Observable<String> {
        return uploadData(config, image.pngData()!, "image/png", "\(outputFileNameWithoutExt).png")
    }

    /// JPEGアップロード
    public static func uploadJPG(_ config: S3UploadConfig,
                                 _ image: UIImage,
                                 _ outputFileNameWithoutExt: String,
                                 compression: CGFloat = 80) -> Observable<String> {
        return uploadData(config,
                          image.jpegData(compressionQuality: compression)!,
                          "image/jpeg",
                          "\(outputFileNameWithoutExt).jpg")
    }

    /// 動画アップロード。サムネイルも。
    public static func uploadVideoWithThumbnail(
        _ config: S3UploadConfig,
        _ fileURL: URL,
        _ outputFileName: String,
        _ thumbnailCreated: ((UIImage) -> Void)? = nil) -> Observable<(String, String)> {
        func generateThumbnail() -> UIImage {
            let imageGenerator = AVAssetImageGenerator(asset: AVAsset(url: fileURL))
            imageGenerator.appliesPreferredTrackTransform = true
            let imageRef = try! imageGenerator.copyCGImage(
                at: CMTimeMake(value: Int64(0), timescale: 1),
                actualTime: nil)
            let image = UIImage(cgImage: imageRef)
            thumbnailCreated?(image)
            return image
        }
        return Observable.zip(
            uploadVideo(config, fileURL, outputFileName),
            uploadPNG(config, generateThumbnail(), outputFileName),
            resultSelector: { (videoKey, thumbnailKey) -> (String, String) in
                return (videoKey, thumbnailKey)
            }
        )
    }

    /// 動画アップロード
    public static func uploadVideo(_ config: S3UploadConfig,
                                   _ fileURL: URL,
                                   _ outputFileName: String) -> Observable<String> {
        return uploadFile(config, fileURL, "video/quicktime", outputFileName)
    }
}

// MARK: - Core
extension AWSS3Service {

    /// ファイルアップロード
    public static func uploadFile(_ config: S3UploadConfig,
                                  _ fileUrl: URL,
                                  _ contentType: String,
                                  _ outputFileName: String? = nil) -> Observable<String> {
        let originalFileName = String(fileUrl.path.split(separator: "/").last!)
        let ext = originalFileName.split(separator: ".").last ?? ""
        let destFileName = outputFileName == nil ? originalFileName : "\(outputFileName!).\(ext)"
        return uploadData(config, try! Data(contentsOf: fileUrl), contentType, destFileName)
    }

    /// データアップロード
    public static func uploadData(_ config: S3UploadConfig,
                                  _ data: Data,
                                  _ contentType: String,
                                  _ outputFileName: String) -> Observable<String> {
        return Observable.create { observer -> Disposable in
            let key = config.generateUploadKey(outputFileName)
            // 一時ディレクトリに保管
            let tmpFileURL = URL(fileURLWithPath: NSTemporaryDirectory().appendingFormat(outputFileName))
            do {
                try data.write(to: tmpFileURL, options: [.atomicWrite])
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
            // Uploading
            let expression = AWSS3TransferUtilityUploadExpression()
            expression.progressBlock = {(task, progress) in
                NSObject.runOnMainThread {
                    config.progressBlock?(progress)
                }
            }
            // Uploaded
            let completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock? = { (task, error) -> Void in
                if let error = error {
                    observer.onError(error)
                } else {
                    try? FileManager.default.removeItem(at: tmpFileURL)
                    NSObject.runAfterDelay(delayMSec: 300, closure: {
                        observer.onNext(key)
                        observer.onCompleted()
                    })
                }
            }
            // Upload
            AWSS3TransferUtility.default().uploadFile(
                tmpFileURL,
                bucket: config.bucket,
                key: key,
                contentType: contentType,
                expression: expression,
                completionHandler: completionHandler
            ).continueWith(block: { (task) -> Void in
                if let error = task.error {
                    observer.onError(error)
                }
            })
            return Disposables.create()
        }
    }
}
