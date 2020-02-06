//
//  DocumentBrowserShowable.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2020/02/07.
//  Copyright © 2020 Arrvis Co., Ltd. All rights reserved.
//

public struct DocumentBrowserInfo {

    /// avaiableExtensions
    public let avaiableExtensions: [String]?

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
        let vc = UIDocumentBrowserViewController(
            forOpeningFilesWithContentTypes: avaiableExtensions?.compactMap { DocumentUtil.documentType(fromExt: $0) }
        )
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
        _ avaiableExtensions: [String]?,
        _ allowsDocumentCreation: Bool,
        _ allowsPickingMultipleItems: Bool,
        _ delegate: UIDocumentBrowserViewControllerDelegate?) {
        let documentBrowserInfo = DocumentBrowserInfo(
            avaiableExtensions: avaiableExtensions,
            allowsDocumentCreation: allowsDocumentCreation,
            allowsPickingMultipleItems: allowsPickingMultipleItems,
            delegate: delegate
        )
        showDocumentBrowser(documentBrowserInfo)
    }
}
