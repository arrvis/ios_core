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
    UIImagePickerControllerDelegate & UINavigationControllerDelegate,
    MediaPickerTypeSelectActionSheetInfoHandler,
    CameraRollEventHandler
    where Self: UIViewController {}

/// Presenter
public protocol PresenterInterface: class {
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

    func onShowOkAlertRequired(title: String?, message: String?, ok: String, onOk: @escaping () -> Void)
    func onShowConfirmAlertRequired(
        title: String?,
        message: String?,
        ok: String,
        onOk: @escaping () -> Void,
        cancel: String,
        onCancel: (() -> Void)?
    )
    func onShowAlertRequired(
        title: String?,
        message: String?,
        actions: [UIAlertAction],
        cancel: String?,
        onCancel: (() -> Void)?
    )
    func onShowActionSheetRequired(
        title: String?,
        message: String?,
        actions: [UIAlertAction],
        cancel: String?,
        onCancel: (() -> Void)?
    )

    func onShowMediaPickerSelectActionSheetScreenRequired(
        _ cameraRollEventHandler: CameraRollEventHandler,
        _ mediaTypes: [CFString])

    func onShowLibraryScreenRequired(_ handler: CameraRollEventHandler, _ mediaTypes: [CFString])
    func onShowCameraScreenRequired(_ handler: CameraRollEventHandler, _ mediaTypes: [CFString])
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
