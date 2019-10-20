//
//  CameraRollEventHandler.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/10/21.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

import Foundation

/// CameraRollEventHandler
public protocol CameraRollEventHandler {
    func onFailAccessCamera()
    func onFailAccessPhotoLibrary()
    func onCanceled()
    func onImageSelected(_ image: UIImage)
    func onMediaSelected(_ url: URL)
}

extension CameraRollEventHandler {
    func onFailAccessCamera() {}
    func onFailAccessPhotoLibrary() {}
    func onCanceled() {}
    func onImageSelected(_ image: UIImage) {}
    func onMediaSelected(_ url: URL) {}
}
