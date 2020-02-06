//
//  DocumentUtil.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2020/02/07.
//  Copyright © 2020 Arrvis Co., Ltd. All rights reserved.
//

import MobileCoreServices

public final class DocumentUtil {

    static func documentType(fromExt ext: String) -> String? {
        return UTTypeCreatePreferredIdentifierForTag(
            kUTTagClassFilenameExtension,
            ext as CFString, nil)?.takeUnretainedValue() as String?
    }
}
