//
//  LocationService.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/04.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import RxSwift
import CoreLocation

/// 位置情報サービス
public final class LocationService: NSObject {

    static let shared: LocationService = LocationService()
    private static let locationManager = CLLocationManager()
    private static var requestAuthorizationObserver: AnyObserver<CLAuthorizationStatus>?

    /// 初期化
    public static func initService() {
        locationManager.delegate = shared
    }

    /// 許可ステータス取得
    public static func fetchAuthorizationStatus() -> Observable<CLAuthorizationStatus> {
        return Observable.create { observer in
            observer.onNext(CLLocationManager.authorizationStatus())
            observer.onCompleted()
            return Disposables.create()
        }
    }

    /// 許可リクエスト
    public static func requestAuthorization(_ needAlways: Bool) -> Observable<CLAuthorizationStatus> {
        return Observable.create { observer in
            requestAuthorizationObserver = observer
            if needAlways {
                locationManager.requestAlwaysAuthorization()
            } else {
                locationManager.requestWhenInUseAuthorization()
            }
            return Disposables.create()
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        LocationService.requestAuthorizationObserver?.onNext(status)
        LocationService.requestAuthorizationObserver?.onCompleted()
    }
}
