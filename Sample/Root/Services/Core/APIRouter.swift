//
//  APIRouter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/04.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import ArrvisCore
import Alamofire

/// APIルータ
final class APIRouter: BaseHTTPRouter {

    #if DEBUG
    override var debugEnabled: Bool {
        return true
    }
    override var maxLogStringLength: Int {
        return 100000
    }
    #endif

    override var headers: HTTPHeaders? {
        return APIRouter.defaultHeaders.merging(APIRouter.additionalHeaders, uniquingKeysWith: +)
    }

    static var additionalHeaders: HTTPHeaders {
        get {
            return UserDefaults.standard.dictionary(forKey: "APIRouter.additionalHeaders") as? HTTPHeaders ?? [:]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "APIRouter.additionalHeaders")
        }
    }

    private static var defaultHeaders: HTTPHeaders {
        return [
            "Accept": "application/json"
        ]
    }

    init(
        path: String,
        httpMethod: HTTPMethod = .get,
        parameters: Codable? = nil) {
        super.init(
            baseURL: baseURL,
            path: path,
            httpMethod: httpMethod,
            parameters: parameters
        )
    }

    static func generateHeaderAddedRequest(_ urlString: String) -> URLRequest {
        var request = URLRequest(url: URL(string: urlString)!)
        additionalHeaders.forEach { (arg) in
            let (key, value) = arg
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }
}

extension UIButton {

    func setImageWithUrlString(for: State, _ urlString: String, _ completion: ((UIImage?) -> Void)? = nil) {
        af_setImage(for: .normal, urlRequest: APIRouter.generateHeaderAddedRequest(urlString)) { response in
            completion?(response.result.value)
        }
    }
}

extension UIImageView {

    func setImageWithUrlString(_ urlString: String, _ completion: ((UIImage?) -> Void)? = nil) {
        af_setImage(withURLRequest: APIRouter.generateHeaderAddedRequest(urlString)) { response in
            completion?(response.result.value)
        }
    }
}
