//
//  DocumentPickerShowable.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2020/02/07.
//  Copyright © 2020 Arrvis Co., Ltd. All rights reserved.
//

public struct DocumentPickerInfo {

    /// avaiableExtensions
    public let avaiableExtensions: [String]

    /// mode
    public let mode: UIDocumentPickerMode

    /// allowsMultipleSelection
    public let allowsMultipleSelection: Bool

    /// delegate
    public weak var delegate: UIDocumentPickerDelegate?

    public func createDocumentPickerViewController() -> UIDocumentPickerViewController {
        let vc = UIDocumentPickerViewController(
            documentTypes: avaiableExtensions.compactMap { DocumentUtil.documentType(fromExt: $0) },
            in: mode)
        vc.allowsMultipleSelection = allowsMultipleSelection
        vc.delegate = delegate
        return vc
    }
}

public protocol DocumentPickerShowable {
    func showDocumentPickerScreen(_ documentPickerInfo: DocumentPickerInfo)
}

extension DocumentPickerShowable {
    public func showDocumentPickerScreen(
        _ avaiableExtensions: [String],
        _ mode: UIDocumentPickerMode,
        _ allowsMultipleSelection: Bool,
        _ delegate: UIDocumentPickerDelegate?) {
        let documentPickerInfo = DocumentPickerInfo(
            avaiableExtensions: avaiableExtensions,
            mode: mode,
            allowsMultipleSelection: allowsMultipleSelection,
            delegate: delegate
        )
        showDocumentPickerScreen(documentPickerInfo)
    }
}
