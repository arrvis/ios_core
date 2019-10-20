//
//  MediaPickerTypeSelectActionSheetInfoHandler.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/10/21.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

/// MediaPickerTypeSelectActionSheetInfoHandler
public protocol MediaPickerTypeSelectActionSheetInfoHandler {
    func sheetTitle() -> String?
    func sheetMessage() -> String?
    func photoLibraryButtonTitle() -> String
    func cameraButtonTitle() -> String
    func cancelButtonTitle() -> String
    func onCancel()
}
