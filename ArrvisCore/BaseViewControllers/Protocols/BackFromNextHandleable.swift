//
//  BackFromNextHandleable.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/03/08.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

/// 次画面から戻ってきたイベントハンドリング可能
public protocol BackFromNextHandleable {

    /// 次画面から戻ってきた
    ///
    /// - Parameter result: result
    func onBackFromNext(_ result: Any?)
}

extension BackFromNextHandleable {

    public func onBackFromNext(_ result: Any?) {}
}
