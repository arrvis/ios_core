//
//  VIPER.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/10/21.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

/// View
public protocol ViewInterface: LoadingShowable,
    ErrorHandleable,
    MediaPickerTypeSelectActionSheetInfoHandler
    where Self: UIViewController {
    func showActivityScreen(
        _ activityItems: [Any],
        _ applicationActivities: [UIActivity]?,
        _ excludedActivityTypes: [UIActivity.ActivityType]?)
    func showOkAlert(
        _ title: String?,
        _ message: String?,
        _ ok: String,
        _ onOk: @escaping () -> Void)
    func showConfirmAlert(
        _ title: String?,
        _ message: String?,
        _ ok: String,
        _ onOk: @escaping () -> Void,
        _ cancel: String,
        _ onCancel: (() -> Void)?)
    func showAlert(
        _ title: String?,
        _ message: String?,
        _ actions: [UIAlertAction],
        _ cancel: String,
        _ onCancel: (() -> Void)?)
    func showActionSheet(
        _ title: String?,
        _ message: String?,
        _ actions: [UIAlertAction],
        _ cancel: String,
        _ onCancel: (() -> Void)?)
    func showMediaPickerSelectActionSheetScreen(_ mediaTypes: [CFString])
    func showLibraryScreen(_ mediaTypes: [CFString])
    func showFaukAccessPhotoLibraryAlert()
    func showCameraScreen(_ mediaTypes: [CFString])
    func showFailAccessCameraAlert()
}

/// Presenter
public protocol PresenterInterface: class,
    CameraRollEventHandler,
    UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func viewDidLoad()
    func viewWillAppear(_ animated: Bool)
    func viewDidAppear(_ animated: Bool)
    func onDidFirstLayoutSubviews()
    func viewWillDisappear(_ animated: Bool)
    func viewDidDisappear(_ animated: Bool)
    func onBackFromNext(_ result: Any?)

    func onShowActivityScreenRequired(
        _ activityItems: [Any],
        _ applicationActivities: [UIActivity]?,
        _ excludedActivityTypes: [UIActivity.ActivityType]?
    )

    func onShowOkAlertRequired(
        _ title: String?,
        _ message: String?,
        _ ok: String,
        _ onOk: @escaping () -> Void
    )
    func onShowConfirmAlertRequired(
        _ title: String?,
        _ message: String?,
        _ ok: String,
        _ onOk: @escaping () -> Void,
        _ cancel: String,
        _ onCancel: (() -> Void)?
    )
    func onShowAlertRequired(
        _ title: String?,
        _ message: String?,
        _ actions: [UIAlertAction],
        _ cancel: String,
        _ onCancel: (() -> Void)?
    )
    func onShowActionSheetRequired(
        _ title: String?,
        _ message: String?,
        _ actions: [UIAlertAction],
        _ cancel: String,
        _ onCancel: (() -> Void)?
    )

    func onShowMediaPickerSelectActionSheetScreenRequired(
        _ handler: MediaPickerTypeSelectActionSheetInfoHandler,
        _ mediaTypes: [CFString]
    )
    func onShowLibraryScreenRequired(_ mediaTypes: [CFString])
    func onShowCameraScreenRequired(_ mediaTypes: [CFString])
}

/// Interactor
public protocol InteractorInterface: class {
}

/// InteractorOutput
public protocol InteractorOutputInterface: class, ErrorHandleable {
}

/// Wireframe
public protocol WireframeInterface: class, SystemScreenShowable {

    /// Navigator
    var navigator: BaseNavigator {get}

    /// モジュール生成
    ///
    /// - Parameter payload: ペイロード
    /// - Returns: UIViewController
    static func generateModule(_ payload: Any?) -> UIViewController
}
