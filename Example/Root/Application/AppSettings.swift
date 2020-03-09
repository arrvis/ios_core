//
//  AppSettings.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/10/01.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import ArrvisCore
import XCGLogger

/// Logger
let logger: XCGLogger? = {
    #if DEBUG
    return XCGLogger.default
    #else
    return nil
    #endif
}()

/// BASE URL
#if DEVELOP
let baseURL = "http://localhost:3000/api/v1"
#elseif STAGING
let baseURL = "http://covantest.vantec-gl.com/api/v1"
#else
let baseURL = "http://localhost:3000/api/v1"
#endif

/// WS URL
#if DEVELOP
let webSocketURL = "ws://localhost:3000/cable"
#elseif STAGING
let webSocketURL = "ws://covantest.vantec-gl.com/cable"
#else
let webSocketURL = "ws://localhost:3000/cable"
#endif

let avaiableImageExtensions = [
    "png",
    "jpg",
    "jpeg",
    "gif"
]
let availableVideoExtensions = [
    "mp4",
    "mov",
    "qt"
]
let avaiableExtensions = [
    "png": nil,
    "jpg": nil,
    "jpeg": nil,
    "gif": nil,
    "mp4": nil,
    "mov": nil,
    "pdf": R.image.attachmentIconPDF(),
    "xls": R.image.attachmentIconXLS(),
    "xlsx": R.image.attachmentIconXLS(),
    "ppt": R.image.attachmentIconPPT(),
    "pptx": R.image.attachmentIconPPT(),
    "doc": R.image.attachmentIconDOC(),
    "docx": R.image.attachmentIconDOC()
]
let previewableExtensions = [
    "pdf"
] + avaiableImageExtensions + availableVideoExtensions

enum FontSize: String {
    case large
    case normal
    case small
}

var appFontSize: FontSize {
    get {
        if let v = UserDefaults.standard.string(forKey: "appFontSize") {
            return FontSize(rawValue: v)!
        }
        return .normal
    }
    set {
        UserDefaults.standard.set(newValue.rawValue, forKey: "appFontSize")
        UserDefaults.standard.synchronize()
    }
}
var fontScaleRatio: CGFloat {
    return appFontSize == .normal ? 1 : (appFontSize == .small ? 0.8 : 1.2)
}
