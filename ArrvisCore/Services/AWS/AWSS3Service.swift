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

public typealias UploadObservable
    = (progress: Observable<Progress>, upload: Observable<(unsignedURL: String, key: String)>)

/// S3サービス
public final class AWSS3Service {

    // MARK: - Variables

    /// DisposeBag
    public static let disposeBag = DisposeBag()

    // MARK: - Initializer

    static func initialize() {
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
    public static func uploadPNG(_ bucket: String,
                                 _ image: UIImage?,
                                 _ keyWithoutExt: String,
                                 _ customConfig: SimplifiedAWSConfig? = nil) -> UploadObservable {
        return uploadData(bucket, image?.pngData(), "image/png", "\(keyWithoutExt).jpg", customConfig)
    }

    /// JPEGアップロード
    public static func uploadJPG(_ bucket: String,
                                 _ image: UIImage?,
                                 _ keyWithoutExt: String,
                                 _ customConfig: SimplifiedAWSConfig? = nil,
                                 _ compression: CGFloat = 100) -> UploadObservable {
        return uploadData(bucket,
                          image?.jpegData(compressionQuality: compression),
                          "image/jpeg",
                          "\(keyWithoutExt).jpg",
            customConfig
        )
    }

    /// 動画をサムネイル付きでアップロード
    public static func uploadVideoWithThumbnail(_ bucket: String,
                                                _ fileURL: URL,
                                                _ outputPath: String,
                                                _ outputFileName: String? = nil,
                                                _ onThumbnailCreated: ((UIImage) -> Void)? = nil,
                                                _ customConfig: SimplifiedAWSConfig? = nil)
        -> (thumbnail: UploadObservable, video: UploadObservable) {
            func generateThumbnail() -> UIImage? {
                let imageGenerator = AVAssetImageGenerator(asset: AVAsset(url: fileURL))
                imageGenerator.appliesPreferredTrackTransform = true
                do {
                    let imageRef
                        = try imageGenerator.copyCGImage(at: CMTimeMake(value: Int64(0), timescale: 1), actualTime: nil)
                    let image = UIImage(cgImage: imageRef)
                    onThumbnailCreated?(image)
                    return image
                } catch {
                    return nil
                }
            }
            let fileName = String(outputFileName ?? String(fileURL.path.split(separator: "/").last!))
            return (
                uploadJPG(bucket,
                          generateThumbnail(),
                          "\(outputPath)/\(fileName.split(separator: ".").last!)",
                          customConfig),
                uploadFile(bucket, fileURL, outputPath, outputFileName, customConfig))
    }
}

// MARK: - Core
extension AWSS3Service {

    /// ファイルアップロード
    public static func uploadFile(_ bucket: String,
                                  _ fileURL: URL,
                                  _ outputPath: String,
                                  _ outputFileName: String? = nil,
                                  _ customConfig: SimplifiedAWSConfig? = nil) -> UploadObservable {
        let fileName: String
        if let originalFileName = fileURL.path.split(separator: "/").last {
            fileName = String(originalFileName)
        } else if let outputFileName = outputFileName {
            fileName = outputFileName
        } else {
            fileName = ""
        }
        return uploadImpl(bucket, { try? Data(contentsOf: fileURL) }, { () -> String? in
            guard let ext = fileName.split(separator: ".").last else {
                return nil
            }
            return String(ext).toMIMETypeFromExt()
        }, "\(outputPath)/\(fileName)", customConfig)
    }

    /// データアップロード
    public static func uploadData(_ bucket: String,
                                  _ data: Data?,
                                  _ contentType: String,
                                  _ key: String,
                                  _ customConfig: SimplifiedAWSConfig? = nil) -> UploadObservable {
        return uploadImpl(bucket, { data }, { contentType }, key, customConfig)
    }

    private static func uploadImpl(_ bucket: String,
                                   _ requireData: @escaping () -> Data?,
                                   _ requireContentType: @escaping () -> String?,
                                   _ key: String,
                                   _ customConfig: SimplifiedAWSConfig? = nil) -> UploadObservable {
        let utility: AWSS3TransferUtility
        let customConfigKey = Date.now.toString("yyyyMMddHHmmss.SSS")
        if let customConfig = customConfig {
            AWSS3TransferUtility.register(with: customConfig.toAWSServiceConfiguration(), forKey: customConfigKey)
            utility = AWSS3TransferUtility.s3TransferUtility(forKey: customConfigKey)!
        } else {
            utility = AWSS3TransferUtility.default()
        }
        // Uploading
        var progressObserver: AnyObserver<Progress>?
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, progress) in
            progressObserver?.onNext(progress)
        }

        return (Observable.create({ observer in
            progressObserver = observer
            return Disposables.create()
        }), Observable.create({ observer in
            guard let data = requireData() else {
                observer.onError(EmptyDataError())
                return Disposables.create()
            }
            guard let contentType = requireContentType() else {
                observer.onError(UnknownFileTypeError())
                return Disposables.create()
            }

            // Uploaded
            let completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock? = { (task, error) -> Void in
                NSObject.runOnMainThread {
                    if let error = error {
                        observer.onError(error)
                    } else {
                        observer.onNext((unsignedURL: getUnsignedUrl(utility.configuration, bucket, key), key: key))
                        AWSS3TransferUtility.remove(forKey: customConfigKey)
                        observer.onCompleted()
                    }
                }
            }

            // Upload
            utility.uploadData(data,
                               bucket: bucket,
                               key: key,
                               contentType: contentType,
                               expression: expression,
                               completionHandler: completionHandler)
                .continueWith(block: { (task) -> Void in
                    if let error = task.error {
                        AWSS3TransferUtility.remove(forKey: customConfigKey)
                        NSObject.runOnMainThread {
                            observer.onError(error)
                        }
                    }
                }
            )
            return Disposables.create()
        }))
    }

    private static func getUnsignedUrl(_ config: AWSServiceConfiguration,
                                       _ bucket: String,
                                       _ key: String) -> String {
        return "https://\(bucket).s3-\(config.regionType.stringValue).amazonaws.com/\(key)"
    }

    /// データが空エラー
    public class EmptyDataError: Error {}

    /// ファイル種別が不明エラー
    public class UnknownFileTypeError: Error {}
}
