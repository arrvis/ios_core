//
//  VIPEREx.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/10/01.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import ArrvisCore
import MobileCoreServices

struct Errors: BaseModel {
    let errors: [String]
}

extension ViewInterface {

    // MARK: - ErrorHandleable

    public func handleError(_ error: Error, _ completion: (() -> Void)?) {
        if !showHTTPError(error, true, completion) {
            showErrorWithLocalizedDescription(error, completion)
        }
    }

    func showErrorWithLocalizedDescription(_ error: Error, _ completion: (() -> Void)?) {
        presenterInterface.onShowOkAlertRequired(
             R.string.localizable.alertTitleError(),
             error.localizedDescription,
             R.string.localizable.ok()) {
                 completion?()
         }
    }

    func showHTTPError(_ error: Error, _ handleUnauthorized: Bool, _ completion: (() -> Void)?) -> Bool {
        if let error = error as? HTTPError, let data = error.data, data.count > 0 {
            let errors = Errors.fromJson(data)
            var index = 0
            func showError() {
                if index > errors.errors.count - 1 {
                    if error.httpStatusCode == .unauthorized && handleUnauthorized {
                        AppDelegate.shared.navigator.navigate(screen: AppScreens.top)
                    }
                    completion?()
                    return
                }
                presenterInterface.onShowOkAlertRequired(
                     R.string.localizable.alertTitleError(),
                     errors.errors[index],
                     R.string.localizable.ok()) {
                        index += 1
                        showError()
                 }
            }
            showError()
            return true
        }
        return false
    }

    // MARK: - MediaPickerTypeSelectActionSheetInfoHandler

    public func sheetTitle() -> String? {
        return R.string.localizable.mediaPickerTypeSelectActionSheetInfoHandlerTitle()
    }

    public func sheetMessage() -> String? {
        return R.string.localizable.mediaPickerTypeSelectActionSheetInfoHandlerMessage()
    }

    public func photoLibraryButtonTitle() -> String {
        return R.string.localizable.mediaPickerTypeSelectActionSheetInfoHandlerPhotoLibraryButtonTitle()
    }

    public func cameraButtonTitle() -> String {
        return R.string.localizable.mediaPickerTypeSelectActionSheetInfoHandlerCameraButtonTitle()
    }

    public func cancelButtonTitle() -> String {
        return R.string.localizable.cancel()
    }

    public func onCancel() {}

    // MARK: - ViewInterface

    public func showFailAccessPhotoLibraryAlert() {
        showOkAlert(
            R.string.localizable.alertTitleError(),
            R.string.localizable.cameraRollEventHandlerOnFailAccessPhotoLibrary(),
            R.string.localizable.ok(), {}
        )
    }

    public func showFailAccessCameraAlert() {
        showOkAlert(
            R.string.localizable.alertTitleError(),
            R.string.localizable.cameraRollEventHandlerOnFailAccessCamera(),
            R.string.localizable.ok(), {}
        )
    }
}

extension PresenterInterface {

    func didTapUser(_ userId: String) {
        (self as? PresenterBase)?.didTapUser(userId)
    }
}

extension InteractorInterface {
}

extension InteractorOutputInterface {
}

extension WireframeInterface {

    var navigator: BaseNavigator {
        return AppDelegate.shared.navigator
    }

    func showAttachmentPreviewScreen(_ url: URL, _ canDownload: Bool = true) {
        navigator.navigate(screen: AppScreens.attachmentPreview, payload: (url, canDownload))
    }

    func showUserProfileScreen(_ userId: String) {
        navigator.navigate(screen: AppScreens.userProfile, payload: userId)
    }
}
