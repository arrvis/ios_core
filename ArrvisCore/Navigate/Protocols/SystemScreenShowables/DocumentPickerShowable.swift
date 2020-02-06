//
//  DocumentPickerShowable.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2020/02/07.
//  Copyright © 2020 Arrvis Co., Ltd. All rights reserved.
//

public struct DocumentPickerInfo {

    /// documentTypes
    public let documentTypes: [String]

    /// mode
    public let mode: UIDocumentPickerMode

    /// allowsMultipleSelection
    public let allowsMultipleSelection: Bool

    /// delegate
    public weak var delegate: UIDocumentPickerDelegate?

    public func createDocumentPickerViewController() -> UIDocumentPickerViewController {
        let vc = UIDocumentPickerViewController(documentTypes: documentTypes, in: mode)
        vc.allowsMultipleSelection = allowsMultipleSelection
        vc.delegate = delegate
        return vc
    }
}

public protocol DocumentPickerShowable {
    func showDocumentPicker(_ documentPickerInfo: DocumentPickerInfo)
}

extension DocumentPickerShowable {
    public func showDocumentPicker(
        _ documentTypes: [String],
        _ mode: UIDocumentPickerMode,
        _ allowsMultipleSelection: Bool,
        _ delegate: UIDocumentPickerDelegate?) {
        let documentPickerInfo = DocumentPickerInfo(
            documentTypes: documentTypes,
            mode: mode,
            allowsMultipleSelection: allowsMultipleSelection,
            delegate: delegate
        )
        showDocumentPicker(documentPickerInfo)
    }
}
