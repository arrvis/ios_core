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

/// S3サービス
public final class AWSS3Service {

    // MARK: - Variables

    /// DisposeBag
    public static let disposeBag = DisposeBag()

    // MARK: - Initialize

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
                                 _ image: UIImage,
                                 _ keyWithoutExt: String,
                                 _ config: SimplifiedAWSConfig? = nil) -> (String, Observable<Progress>) {
        return uploadData(bucket, image.pngData()!, "image/png", "\(keyWithoutExt).jpg", config)
    }

    /// JPEGアップロード
    public static func uploadJPG(_ bucket: String,
                                 _ image: UIImage,
                                 _ keyWithoutExt: String,
                                 _ config: SimplifiedAWSConfig? = nil,
                                 _ compression: CGFloat = 100) -> (String, Observable<Progress>) {
        return uploadData(bucket,
                          image.jpegData(compressionQuality: compression)!,
                          "image/jpeg",
                          "\(keyWithoutExt).jpg",
                          config
        )
    }

    /// 動画アップロード
    public static func uploadVideo(_ bucket: String,
                                   _ fileURL: URL,
                                   _ outputPath: String,
                                   _ outputFileName: String?,
                                   _ config: SimplifiedAWSConfig? = nil) -> (String, Observable<Progress>) {
        return uploadFile(bucket, fileURL, "video/quicktime", outputPath, outputFileName, config)
    }
}

// MARK: - Core
extension AWSS3Service {

    /// ファイルアップロード
    public static func uploadFile(_ bucket: String,
                                  _ fileUrl: URL,
                                  _ contentType: String,
                                  _ outputPath: String,
                                  _ outputFileName: String? = nil,
                                  _ config: SimplifiedAWSConfig? = nil) -> (String, Observable<Progress>) {
        let fileName = outputFileName ?? String(fileUrl.path.split(separator: "/").last!)
        return uploadData(bucket, try! Data(contentsOf: fileUrl), contentType, "\(outputPath)/\(fileName)", config)
    }

    /// データアップロード
    public static func uploadData(_ bucket: String,
                                  _ data: Data,
                                  _ contentType: String,
                                  _ key: String,
                                  _ config: SimplifiedAWSConfig? = nil) -> (String, Observable<Progress>) {
        let utility: AWSS3TransferUtility
        if let config = config {
            AWSS3TransferUtility.register(with: config.toAWSServiceConfiguration(), forKey: "Config")
            utility = AWSS3TransferUtility.s3TransferUtility(forKey: "Config")!
        } else {
            utility = AWSS3TransferUtility.default()
        }

        return (getUrl(utility.configuration, bucket, key), Observable.create { observer -> Disposable in
            // Uploading
            let expression = AWSS3TransferUtilityUploadExpression()
            expression.progressBlock = {(task, progress) in
                observer.onNext(progress)
            }

            // Uploaded
            let completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock? = { (task, error) -> Void in
                if let error = error {
                    AWSS3TransferUtility.remove(forKey: "Config")
                    NSObject.runOnMainThread {
                        observer.onError(error)
                    }
                } else {
                    AWSS3TransferUtility.remove(forKey: "Config")
                    NSObject.runAfterDelay(delayMSec: 300, closure: {
                        observer.onCompleted()
                    })
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
                        AWSS3TransferUtility.remove(forKey: "Config")
                        NSObject.runOnMainThread {
                            observer.onError(error)
                        }
                    }
                }
            )
            return Disposables.create()
        })
    }

    private static func getUrl(_ config: AWSServiceConfiguration,
                               _ bucket: String,
                               _ key: String) -> String {
        return "https://s3-\(config.regionType.stringValue).amazonaws.com/\(bucket)/\(key)"
    }
}
