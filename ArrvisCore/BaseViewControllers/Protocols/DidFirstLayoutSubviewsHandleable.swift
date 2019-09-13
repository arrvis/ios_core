//
//  DidFirstLayoutSubviewsHandleable.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/07/02.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

/// didFirstlayoutSubviewsハンドリング可能
public protocol DidFirstLayoutSubviewsHandleable {
    func onDidFirstLayoutSubviews()
}

extension DidFirstLayoutSubviewsHandleable {

    public func onDidFirstLayoutSubviews() {}
}
