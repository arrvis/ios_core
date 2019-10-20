//
//  CameraRollEventHandler.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/10/21.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

/// CameraRollEventHandler
public protocol CameraRollEventHandler {
    func onFailAccessCamera()
    func onFailAccessPhotoLibrary()
    func onImagePickCanceled()
    func onImageSelected(_ image: UIImage)
    func onMediaSelected(_ url: URL)
}
