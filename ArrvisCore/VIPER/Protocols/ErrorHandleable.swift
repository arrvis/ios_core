//
//  ErrorHandleable.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/09/25.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

/// エラーハンドリング可能
public protocol ErrorHandleable {
    func handleError(_ error: Error, _ completion: (() -> Void)?)
}
