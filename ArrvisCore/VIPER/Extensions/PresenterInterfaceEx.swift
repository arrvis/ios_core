//
//  PresenterInterfaceEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/11/07.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

private var payloadKey = 0

extension PresenterInterface {

    /// Payload
    public var payload: Any? {
        get {
            return objc_getAssociatedObject(self, &payloadKey)
        }
        set {
            objc_setAssociatedObject(self, &payloadKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
