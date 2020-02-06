//
//  DocumentBrowserShowable.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2020/02/07.
//  Copyright © 2020 Arrvis Co., Ltd. All rights reserved.
//

public struct DocumentBrowserInfo {

    /// forOpeningFilesWithContentTypes
    public let forOpeningFilesWithContentTypes: [String]?

    /// allowsDocumentCreation
    public let allowsDocumentCreation: Bool

    /// allowsPickingMultipleItems
    public let allowsPickingMultipleItems: Bool

    /// delegate
    public weak var delegate: UIDocumentBrowserViewControllerDelegate?

    /// UIDocumentBrowserViewController生成
    ///
    /// - Returns: UIDocumentBrowserViewController
    public func createDocumentBrowserViewController() -> UIDocumentBrowserViewController {
        let vc = UIDocumentBrowserViewController(forOpeningFilesWithContentTypes: forOpeningFilesWithContentTypes)
        vc.allowsDocumentCreation = allowsDocumentCreation
        vc.allowsPickingMultipleItems = allowsPickingMultipleItems
        vc.delegate = delegate
        return vc
    }
}

public protocol DocumentBrowserShowable {
    func showDocumentBrowser(_ documentBrowserInfo: DocumentBrowserInfo)
}

extension DocumentBrowserShowable {
    public func showDocumentBrowser(
        _ forOpeningFilesWithContentTypes: [String]?,
        _ allowsDocumentCreation: Bool,
        _ allowsPickingMultipleItems: Bool,
        _ delegate: UIDocumentBrowserViewControllerDelegate?) {
        let documentBrowserInfo = DocumentBrowserInfo(
            forOpeningFilesWithContentTypes: forOpeningFilesWithContentTypes,
            allowsDocumentCreation: allowsDocumentCreation,
            allowsPickingMultipleItems: allowsPickingMultipleItems,
            delegate: delegate
        )
        showDocumentBrowser(documentBrowserInfo)
    }
}
