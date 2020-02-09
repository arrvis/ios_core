//
//  VIPER.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/10/21.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

// TODO: 後で読む https://qiita.com/shiz/items/992e15815b9a092110b6

/// View
public protocol ViewInterface: LoadingShowable,
    ErrorHandleable,
    MediaPickerTypeSelectActionSheetInfoHandler
    where Self: UIViewController {
    func showFailAccessPhotoLibraryAlert()
    func showFailAccessCameraAlert()
}

/// Presenter
public protocol PresenterInterface: NSObject,
    CameraRollEventHandler,
    UIImagePickerControllerDelegate & UINavigationControllerDelegate,
    UIDocumentBrowserViewControllerDelegate,
    UIDocumentPickerDelegate {
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
    func onShowLibraryScreenRequired(_ availableExtensions: [String])
    func onShowCameraScreenRequired(_ mediaTypes: [CFString])
    func onShowCameraScreenRequired(_ availableExtensions: [String])

    func onShowDocumentBrowserScreenRequired(
        _ avaiableExtensions: [String]?,
        _ allowsDocumentCreation: Bool,
        _ allowsPickingMultipleItems: Bool)
    func onShowDocumentPickerScreenRequired(
       _ avaiableExtensions: [String],
       _ mode: UIDocumentPickerMode,
       _ allowsMultipleSelection: Bool)
}

/// Interactor
public protocol InteractorInterface: class {
}

/// InteractorOutput
public protocol InteractorOutputInterface: class, ErrorHandleable {
}

/// Wireframe
public protocol WireframeInterface: SystemScreenShowable {

    /// Navigator
    var navigator: BaseNavigator {get}

    /// モジュール生成
    ///
    /// - Parameter payload: ペイロード
    /// - Returns: UIViewController
    static func generateModule(_ payload: Any?) -> UIViewController
}
