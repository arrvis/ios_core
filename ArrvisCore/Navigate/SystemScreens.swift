//
//  SystemScreens.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/09/14.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import MobileCoreServices

/// システムスクリーン
public enum SystemScreens: String, CaseIterable, Screen {
    case alert
    case actionSheet
    case activity
    case imagePicker

    public var path: String {
        return rawValue
    }

    public var transition: NavigateTransions {
        switch self {
        case .imagePicker, .alert, .actionSheet, .activity:
            return .present
        }
    }

    public func createViewController(_ payload: Any? = nil) -> UIViewController {
        switch self {
        case .alert:
            guard let payload = payload as? AlertInfo else {
                fatalError("required payload type AlertInfo")
            }
            return payload.createAlertController(.alert)
        case .actionSheet:
            guard let payload = payload as? AlertInfo else {
                fatalError("required payload type AlertInfo")
            }
            return payload.createAlertController(.actionSheet)
        case .activity:
            guard let payload = payload as? ActivityInfo else {
                fatalError("required payload type ActivityInfo")
            }
            return payload.createActivityViewController()
        case .imagePicker:
            guard let payload = payload as? ImagePickerInfo else {
                fatalError("required payload type ImagePickerInfo")
            }
            return payload.createImagePickerController()
        }
    }
}
